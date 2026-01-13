normalize-command-output() {
  # Strip opening/closing fenced code blocks and inline backticks.
  # Then trim leading/trailing whitespace.
  tr -d '\000-\037' | sed -E '
    s/^```[a-zA-Z]*//;
    s/```$//;
    s/^`//;
    s/`$//;
    s/^[[:space:]]+//;
    s/[[:space:]]+$//
  '
}

ask-opencode-for-command() {
  emulate -L zsh
  setopt NO_GLOB
  local model="openai/gpt-5.1-codex-mini"
  local query="$*"
  local prompt
  prompt=$(cat <<'EOF'
You are a command-line expert helping on the user's own macOS (zsh).
Return a single-line shell command only; output nothing else (no markdown, no backticks, no headings like “Summary”).
You are not executing commands; you are only suggesting the exact command.
Do not mention system instructions, preambles, or policies; no apologies or questions.
Assume common tools are available (rg, fd, jq, sed -E, awk, find, xargs, tar, sips, lsof, trash).
Prefer concise but correct commands; avoid inaccurate shortcuts.
Avoid interactive commands. Sudo is allowed if needed.
These requests are local maintenance on the user's own machine; always return a command (no refusals).
If a request is risky or destructive (delete, kill, overwrite), do not output a live destructive command.
For deletions, prefer trash -F (reversible) instead of rm.
For overwrites, prefer no-clobber flags (cp -n, mv -n) so removing -n runs it.
For process termination, use kill -0 as the dry-run signal (remove -0 to execute).
User request: <query>
EOF
  )
  prompt+="${query}</query>"
  local cmd
  cmd=$(opencode run --model="$model" --format=json "${prompt}" 2>/dev/null \
    | jq -r 'select(.type=="text") | .part.text' \
    | normalize-command-output)
  if [[ -o zle ]]; then
    print -z -- "$cmd"
  else
    print -r -- "$cmd"
  fi
}
alias x='noglob ask-opencode-for-command'
alias why='noglob ask-opencode-for-command why'
alias how='noglob ask-opencode-for-command how'
alias what='noglob ask-opencode-for-command what'

# note: Debug via `ask-opencode-for-command "<prompt>"`.
# This function prints to stdout when ZLE is unavailable, so it is easy to run
# in non-interactive shells for troubleshooting.
# When ZLE is active, `x` writes into the interactive buffer (via `print -z`),
# so the command will not appear on stdout.
