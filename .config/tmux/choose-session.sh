#!/usr/bin/env sh

sesh connect "$(sesh list -t | fzf-tmux -p 55%,60% \
  --no-sort --border-label ' sesh ' --prompt '   ' \
  --header '  <C-a> all <C-t> tmux <C-x> zoxide <C-d> tmux kill <C-f> find' \
  --bind 'tab:down,btab:up' \
  --bind 'ctrl-a:change-prompt(   )+reload(sesh list -tz)' \
  --bind 'ctrl-t:change-prompt(   )+reload(sesh list -t)' \
  --bind 'ctrl-x:change-prompt(󱃪   )+reload(sesh list -z)' \
  --bind 'ctrl-f:change-prompt(   )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
  --bind 'ctrl-d:execute(tmux kill-session -t {})+change-prompt(   )+reload(sesh list -t)')"
