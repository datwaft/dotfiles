#!/usr/bin/env sh

prompt_all=' '
prompt_tmux=' '
prompt_zoxide='󰤏 '
prompt_find='󱦞 '

# shellcheck disable=SC2016
sesh connect "$(sesh list -t | fzf-tmux -p 55%,60% \
  --color=bg+:#1e1e2e,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#cba6f7 \
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#cba6f7 \
  --reverse --no-scrollbar --pointer='➤ ' --info=default --no-sort --border=sharp \
  --prompt="${prompt_tmux}  " \
  --header=[2m'^a all ∣ ^t tmux ∣ ^x zoxide ∣ ^d kill ∣ ^f find'[22m \
  --preview='tmux capture-pane -e -p -t {} 2> /dev/null || \
             eza -I "Icon" --color=always -1 (string replace "~" $HOME {})' \
  --preview-window='right,border-sharp,<50(down)' \
  --bind='tab:down,btab:up' \
  --bind="ctrl-a:change-prompt(${prompt_all}  )+reload(sesh list -tz)" \
  --bind="ctrl-t:change-prompt(${prompt_tmux}  )+reload(sesh list -t)" \
  --bind="ctrl-x:change-prompt(${prompt_zoxide}  )+reload(sesh list -z)" \
  --bind="ctrl-f:change-prompt(${prompt_find}  )+reload(fd -H -d 2 -t d -E .Trash . ~)" \
  --bind="ctrl-d:execute(tmux kill-session -t {})+change-prompt(${prompt_tmux}  )+reload(sesh list -t)")"
