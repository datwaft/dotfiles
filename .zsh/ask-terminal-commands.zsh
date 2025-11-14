ask-codex-for-command() {
  emulate -L zsh
  setopt NO_GLOB
  local query="$*"
  local prompt="You are a command line expert. The user wants to run a command but they don't know how. Here is what they asked: <query>${query}</query>. Return ONLY the exact shell command needed. Do not prepend with an explanation, no markdown, no code blocks - just return the raw command you think will solve their query. Minimize access to tools/environment. Prefer quick and dirty over correctness."
  local cmd
  cmd=$(codex --model='gpt-5.1-codex-mini' --sandbox='read-only' exec --skip-git-repo-check --color=never "${prompt}" 2>/dev/null | tr -d '\000-\037' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  print -z -- "$cmd"
}
alias x='noglob ask-codex-for-command'
alias why='noglob ask-codex-for-command why'
alias how='noglob ask-codex-for-command how'
alias what='noglob ask-codex-for-command what'
