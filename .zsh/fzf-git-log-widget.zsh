FZF_CTRL_G_L_COMMAND=(
  git log
  --oneline
  --color=always
)

FZF_CTRL_G_L_OPTS=(
  --height -40%
  --inline-info
  --ansi
  --reverse
  --tiebreak=index
  --no-sort
  --preview
    $'
    f() {
      set -- $(echo "$@" | awk \'{print $1}\');
      [ $# -eq 0 ] || git show --color=always $1;
    }; f {}
    '
)

fzf-git-log-widget() {
  local results
  local selected
  if results=$("${FZF_CTRL_G_L_COMMAND[@]}" 2> /dev/null) &&
     selected=$(echo $results | fzf "${FZF_CTRL_G_L_OPTS[@]}" | awk '{print $1}'); then
    LBUFFER="$LBUFFER${selected}"
  fi
  zle redisplay
}
zle -N fzf-git-log-widget
