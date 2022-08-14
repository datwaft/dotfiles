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
  zsh-syntax-highlighting
  zsh-vi-mode
)

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

## ==========================
## Configuration finalization
## ==========================
# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh
# Load Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# Load .zshenv
source $HOME/.zshenv
