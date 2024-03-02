# `ls` related aliases
if [ -x "$(command -v exa)" ]; then
  alias ls="exa -I $'Icon\r'"
  alias la="ls -a"
  alias l="ls -l"
  alias ll="ls -l"
  alias lla="ls -la"
  alias tree="ls -T"
fi
# `trash` command
if [ -x "$(command -v trash)" ]; then
  alias trash="trash -F"
fi
# `neovide` related aliases
if [ -x "$(command -v neovide)" ]; then
  alias nvd="neovide"
  alias vid="neovide"
fi
# `pwsh` (Powershell) command
if [ -x "$(command -v pwsh)" ]; then
  alias pwsh="TERM=xterm-256color pwsh"
fi
# `ssh` command
if [ -x "$(command -v ssh)" ]; then
  alias ssh="TERM=xterm-256color ssh"
fi
# `neovim` related aliases
if [ -x "$(command -v nvim)" ]; then
  alias vi="nvim"
  alias vim="nvim"
fi
# `cd` related alises
if [ -x "$(command -v zoxide)" ]; then
  alias cd="z"
fi
