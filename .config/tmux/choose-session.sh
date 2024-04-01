#!/usr/bin/env sh

sesh connect "$(sesh list -t | fzf-tmux -p 55%,60% \
  --reverse --info=inline --no-scrollbar --pointer '➤ ' \
  --no-sort --border-label [1m[3m' Choose Session '[22m[23m --prompt '   ' \
  --header [34m'󰌌  ''<C-a> '[1m'all |'[22m' <C-t> '[1m'tmux |'[22m' <C-x> '[1m'zoxide |'[22m' <C-d> '[1m'tmux kill |'[22m' <C-f> '[1m'find'[22m[39m \
  --preview 'tmux capture-pane -e -p -t {}' --preview-label [1m[3m' Session Preview '[22m[23m \
  --preview-window 'right,<50(down)' \
  --bind 'tab:down,btab:up' \
  --bind 'ctrl-a:change-prompt(   )+reload(sesh list -tz)' \
  --bind 'ctrl-t:change-prompt(   )+reload(sesh list -t)' \
  --bind 'ctrl-x:change-prompt(󱃪   )+reload(sesh list -z)' \
  --bind 'ctrl-f:change-prompt(   )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
  --bind 'ctrl-d:execute(tmux kill-session -t {})+change-prompt(   )+reload(sesh list -t)')"
