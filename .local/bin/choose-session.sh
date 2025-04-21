#!/usr/bin/env bash

prompt_all='^a  '
prompt_tmux='^t  '
prompt_zoxide='^x  '

export TMUX_PANE=1

command_all=(sesh list --zoxide --tmux)
command_tmux=(sesh list --tmux)
command_zoxide=(sesh list --zoxide)

sesh connect "$("${command_tmux[@]}" | fzf --tmux 55%,60% \
  --color=bg+:-1,bg:-1,spinner:#f5e0dc,hl:#f38ba8,gutter:-1 \
  --color=fg:#cdd6f4,header:#f38ba8,info:-1,pointer:#cba6f7 \
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#cba6f7 \
  --reverse --no-scrollbar --pointer='➤ ' --info=hidden --no-sort --border=sharp \
  --prompt="${prompt_tmux}" \
  --header=[2m'^a all ∣ ^t tmux ∣ ^x zoxide ∣ ^d kill'[22m \
  --preview=$'
    f() {
      set -- $(eval echo "$@")
      [ $# -eq 0 ] || tmux capture-pane -e -p -t "=$@:" 2> /dev/null \
                   || eza -I $\'Icon\r\' --color=always -1 "$@"
    }; f {}
  ' \
  --preview-window='right,border-sharp,<50(down)' \
  --bind='tab:down,btab:up' \
  --bind="ctrl-a:change-prompt(${prompt_all})+reload(${command_all[*]})" \
  --bind="ctrl-t:change-prompt(${prompt_tmux})+reload(${command_tmux[*]})" \
  --bind="ctrl-x:change-prompt(${prompt_zoxide})+reload(${command_zoxide[*]})" \
  --bind="ctrl-d:execute(tmux kill-session -t {})+change-prompt(${prompt_tmux})+reload(${command_tmux[*]})")" > /dev/null
