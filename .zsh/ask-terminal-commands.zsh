validate-command-awk() {
  emulate -L zsh
  local -a words
  words=("${(@z)1}")
  local word command_name program
  local at_command=1 awk_source=0 option_value=0
  # Inspect simple commands/pipelines; never evaluate shell expansions.
  for word in "${words[@]}"; do
    case "$word" in
      '|'|'|&'|';'|'&&'|'||'|'(')
        at_command=1 awk_source=0 option_value=0
        continue
        ;;
    esac
    if (( at_command )); then
      [[ "$word" =~ '^[A-Za-z_][A-Za-z0-9_]*=' ]] && continue
      command_name="${(Q)word}"
      [[ "$command_name" == command || "$command_name" == noglob ]] && continue
      at_command=0
      [[ "$command_name" == awk || "$command_name" == /usr/bin/awk ]] && awk_source=1
      continue
    fi
    (( awk_source )) || continue
    if (( option_value )); then
      option_value=0
      continue
    fi
    case "$word" in
      -F|-v) option_value=1 ;;
      -F?*|-v?*|--) ;;
      -*) awk_source=0 ;; # External programs/other options are not checked.
      *)
        awk_source=0
        # Only a wholly single-quoted literal can be checked without expansion.
        if [[ "$word" == \'*\' && "${word[2,-2]}" != *\'* ]]; then
          program="${word[2,-2]}"
          # awk compiles the complete source first. Both guards are needed:
          # exiting BEGIN still runs END, whose first guard skips user actions.
          if ! command /usr/bin/awk $'BEGIN { exit } END { exit }\n'"$program" < /dev/null > /dev/null; then
            print -u2 -- 'ask: Claude Code returned invalid awk syntax.'
            return 1
          fi
        fi
        ;;
    esac
  done
  return 0
}

ask-claude-for-command() {
  emulate -L zsh
  setopt NO_GLOB PIPE_FAIL
  local model="claude-haiku-5-5"
  local query="$*"
  if [[ -z "$query" ]]; then
    print -u2 -- 'Usage: x <request>'
    return 2
  fi
  local prompt
  prompt=$(cat <<'EOF'
Suggest a concise, correct command for macOS zsh using BSD system utilities and installed rg, fd, jq, trash, and jj.
Return the structured response specified by the schema. The command field is inserted into the user's terminal buffer for review: use exactly one line of shell code, without markdown or surrounding backticks.
Use macOS-supported flags, quote literal arguments, and preserve filenames containing spaces. Prefer noninteractive commands and correctness over brevity.
For deletion, use trash -F. For moves or copies, preserve existing destinations with no-clobber options; for other writes, check that the destination does not exist. For process termination, output kill -0 as a preview.
When selecting processes, match the executable name, not occurrences in its arguments.
Prefer pgrep -x with ps for process lookups. In slash-delimited awk regexes, escape literal slashes as \/; prefer exact comparisons when regexes are unnecessary.
Use status "ok" with a command and null message for ordinary answers. Use "warning" with a command and a brief message only for potential data loss, security exposure, or a limitation that materially changes what the command accomplishes. Skip routine explanations.
For refusals or missing information that prevents a correct command, use "blocked" with null command and a brief explanation in message. Never put commentary in command.
EOF
  )
  local schema='{"type":"object","properties":{"status":{"type":"string","enum":["ok","warning","blocked"]},"command":{"type":["string","null"]},"message":{"type":["string","null"]}},"required":["status","command","message"],"additionalProperties":false}'
  local response cli_exit=0
  response=$(command claude -p --model "$model" --effort medium \
    --tools '' --strict-mcp-config --mcp-config '{"mcpServers":{}}' \
    --disable-slash-commands --no-session-persistence --setting-sources '' \
    --system-prompt "$prompt" \
    --output-format json --json-schema "$schema" \
    < <(print -r -- "$query")) || cli_exit=$?

  # CLI diagnostics already go to stderr; failures inside a run may be in stdout.
  if ! print -r -- "$response" | jq -e -s 'length == 1 and (.[0] | type == "object")' > /dev/null; then
    print -u2 -- 'ask: Claude Code returned an invalid or empty response.'
    [[ -z "$response" ]] || print -ru2 -- "$response"
    return $(( cli_exit != 0 ? cli_exit : 1 ))
  fi
  local message
  if (( cli_exit != 0 )) || print -r -- "$response" | jq -e '.is_error == true' > /dev/null; then
    message=$(print -r -- "$response" | jq -r '[.result?, .errors[]?] | map(select(type == "string" and length > 0)) | join("\n")') || return 1
    print -ru2 -- "ask: ${message:-Claude Code failed without a diagnostic.}"
    return $(( cli_exit != 0 ? cli_exit : 1 ))
  fi

  # A server-side refusal can bypass the schema. Display it, never insert it.
  if ! print -r -- "$response" | jq -e '.structured_output | type == "object"' > /dev/null; then
    message=$(print -r -- "$response" | jq -r '.result | select(type == "string" and length > 0)') || return 1
    print -u2 -- 'ask: No structured command was returned.'
    [[ -z "$message" ]] || print -ru2 -- "$message"
    return 1
  fi
  if ! print -r -- "$response" | jq -e '
    .structured_output |
    keys == ["command", "message", "status"] and
    (if .status == "ok" then
      (.command | type == "string") and .message == null
    elif .status == "warning" then
      (.command | type == "string") and (.message | type == "string" and test("\\S"))
    elif .status == "blocked" then
      .command == null and (.message | type == "string" and test("\\S"))
    else false end)
  ' > /dev/null; then
    print -u2 -- 'ask: Claude Code returned an invalid structured response.'
    message=$(print -r -- "$response" | jq -r '.structured_output.message | select(type == "string" and length > 0)') || return 1
    [[ -z "$message" ]] || print -ru2 -- "$message"
    return 1
  fi
  local response_kind cmd
  response_kind=$(print -r -- "$response" | jq -r '.structured_output.status') || return 1
  message=$(print -r -- "$response" | jq -r '.structured_output.message // empty') || return 1
  [[ -z "$message" ]] || print -ru2 -- "ask: $response_kind: $message"
  [[ "$response_kind" != blocked ]] || return 1

  if ! print -r -- "$response" | jq -e '
    .structured_output.command |
    test("\\S") and (test("[[:cntrl:]]") | not) and
    (test("^\\s*`") | not)
  ' > /dev/null; then
    print -u2 -- 'ask: Expected one nonempty command line without control characters or markdown backticks.'
    return 1
  fi
  cmd=$(print -r -- "$response" | jq -r '.structured_output.command | gsub("^\\s+|\\s+$"; "")') || return 1
  if ! command zsh -fn -c "$cmd"; then
    print -u2 -- 'ask: Claude Code returned invalid zsh syntax.'
    return 1
  fi
  validate-command-awk "$cmd" || return $?
  if [[ -o zle ]]; then
    print -z -- "$cmd"
  else
    print -r -- "$cmd"
  fi
}
alias x='noglob ask-claude-for-command'
alias why='noglob ask-claude-for-command why'
alias how='noglob ask-claude-for-command how'
alias what='noglob ask-claude-for-command what'

# note: Debug via `ask-claude-for-command "<prompt>"`.
# This function prints to stdout when ZLE is unavailable, so it is easy to run
# in non-interactive shells for troubleshooting.
# When ZLE is active, `x` writes into the interactive buffer (via `print -z`),
# so the command will not appear on stdout.
