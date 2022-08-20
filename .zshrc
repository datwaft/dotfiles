## ==============
## Initialization
## ==============
# Start inside TMUX
if [ -x "$(command -v tmux)" ]; then
  export TERM="tmux-256color"
  if [[ "$TERM_PROGRAM" == 'vscode' ]]; then
    exec tmux new-session -A -s "vscode-$(pwd | xargs basename)"
  elif [ ! -n "$TMUX" ]; then
    exec tmux new-session -A -s default
  fi
fi
# Use Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# Configure maximum number of open files
ulimit -n 10240

## =======================
## Oh My Zsh configuration
## =======================
# Define Oh My Zsh home folder
export ZSH="$HOME/.oh-my-zsh"
# Define plugins
plugins=(
  dotenv # Automatically load .env variables
  command-not-found # Suggest packages on command not found
  asdf
  poetry
  # -- Custom plugins --
  zsh-syntax-highlighting
  zsh-vi-mode
)
# Add completions to fpath
fpath+=$HOMEBREW_PREFIX/share/zsh/site-functions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

## ============================
## Configure zsh-vi-mode plugin
## ============================
# Use s-prefix mode
ZVM_VI_SURROUND_BINDKEY=s-prefix

## =======================
## Aesthetic configuration
## =======================
# Better LS_COLORS
export LS_COLORS="$LS_COLORS:ow=1;7;34:st=30;44:su=30;41"
# Change theme
ZSH_THEME="powerlevel10k/powerlevel10k"

## ========================
## Completion configuration
## ========================
# Make completion hypen-insensitive
HYPHEN_INSENSITIVE=true

## =====================
## History configuration
## =====================
# Change timestamp format
HIST_STAMPS="yyyy-mm-dd"

## ======================
## Keyboard configuration
## ======================
# Ability to travel the menu backwards with <S-Tab>
bindkey '^[[Z' reverse-menu-complete
# Use <up> and <down> to search on history
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search # <Up>
bindkey '^[[B' down-line-or-beginning-search # <Down>
# Set MacOS shortcuts
bindkey '^[[1;3D' backward-word # ⌥+<Left>
bindkey '^[[1;3C' forward-word # ⌥+<Right>

## ==========================
## Configuration finalization
## ==========================
# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh
# Load Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

## =======
## Aliases
## =======
  # ------------------
  # Dotfiles using git
  # ------------------
    if [ -d "$HOME/.dotfiles" ]; then
      alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
      alias gitd='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    fi
  # -----
  # Trash
  # -----
    if [ -x "$(command -v trash)" ]; then
      alias rm='trash'
    fi
  # ---------
  # ls or exa
  # ---------
    if [ -x "$(command -v exa)" ]; then
      alias ls='exa'
      alias lsa='exa -a'
      alias l='exa -l'
      alias la='exa -la'
    else
      alias ls='ls --color=auto'
      alias lsa='ls --color=auto -a'
      alias la='ls --color=auto -l'
      alias la='ls --color=auto -la'
    fi
