#!/usr/bin/env sh

# shellcheck disable=SC2016
sesh connect "$(sesh list -t | fzf-tmux -p 55%,60% \
  --color=bg+:#1e1e2e,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --reverse --no-scrollbar --pointer '➤ ' --info=inline-right \
  --no-sort --border-label [1m[3m' Choose Session '[22m[23m --prompt '   ' \
  --header [2m'   ^a all ∣ ^t tmux ∣ ^x zoxide ∣ ^d kill ∣ ^f find'[22m \
  --preview 'tmux capture-pane -e -p -t {} 2> /dev/null || \
             eza -I "Icon" --color=always -1 (string replace "~" $HOME {})' \
  --preview-label [1m[3m' Session Preview '[22m[23m \
  --preview-window 'right,<50(down)' \
  --bind 'tab:down,btab:up' \
  --bind 'ctrl-a:change-prompt(   )+reload(sesh list -tz)' \
  --bind 'ctrl-t:change-prompt(   )+reload(sesh list -t)' \
  --bind 'ctrl-x:change-prompt(󱃪   )+reload(sesh list -z)' \
  --bind 'ctrl-f:change-prompt(   )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
  --bind 'ctrl-d:execute(tmux kill-session -t {})+change-prompt(   )+reload(sesh list -t)')"
