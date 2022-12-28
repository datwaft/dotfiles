## ==============
## Initialization
## ==============
# Use Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# Configure maximum number of open files
ulimit -n 10240

## ============================
## Configure zsh-vi-mode plugin
## ============================
function zvm_config() {
  # Use s-prefix mode
  ZVM_VI_SURROUND_BINDKEY=s-prefix
}

## =======================
## Aesthetic configuration
## =======================
# Better LS_COLORS
export LS_COLORS="$LS_COLORS:ow=1;7;34:st=30;44:su=30;41"
# Change theme
ZSH_THEME="powerlevel10k/powerlevel10k"
# bat theme
export BAT_THEME="Catppuccin-mocha"

## ========================
## Completion configuration
## ========================
# Make completion hyphen-insensitive
HYPHEN_INSENSITIVE=true

## =====================
## History configuration
## =====================
# Change timestamp format
HIST_STAMPS="yyyy-mm-dd"

## ======================
## Keyboard configuration
## ======================
function zvm_after_init() {
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
}

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
  direnv
  git
  # -- Custom plugins --
  fast-syntax-highlighting
  zsh-vi-mode
)
# Add completions to fpath
fpath+=$HOMEBREW_PREFIX/share/zsh/site-functions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

## ====================
## Binary configuration
## ====================
# Homebrew
if [ -d "/opt/homebrew" ]; then
  eval $(/opt/homebrew/bin/brew shellenv)
fi
# Cargo
if [ -d "$HOME/.cargo" ] ; then
  source "$HOME/.cargo/env"
fi
# Anaconda
__conda_setup="$("$HOME/opt/anaconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
  eval "$__conda_setup"
else
  if [ -f "$HOME/opt/anaconda3/etc/profile.d/conda.sh" ]; then
    . "$HOME/opt/anaconda3/etc/profile.d/conda.sh"
  else
    export PATH="$HOME/opt/anaconda3/bin:$PATH"
  fi
fi
unset __conda_setup
# Luarocks
if [ -x "$(command -v luarocks)" ]; then
  eval "$(luarocks path --bin)"
fi

## ==============
## User variables
## ==============
export NVIM="$HOME/.config/nvim"

## ==================
## Binaries variables
## ==================
# Java
if [ -d "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home" ]; then
  export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"
elif [ -x "$(command -v brew)" ] && [ -d "$(brew --prefix)/opt/java" ]; then
  export JAVA_HOME="$(brew --prefix)/opt/java"
fi
# Prettierd
export PRETTIERD_DEFAULT_CONFIG="$HOME/.prettierrc.json"
# Deno
if [ -d "$HOME/.deno" ]; then
  export DENO_INSTALL="$HOME/.deno"
fi
# SDKMAN
if [ -d "$HOME/.sdkman" ]; then
  export SDKMAN_DIR="$HOME/.sdkman"
fi

## =============
## PATH variable
## =============
# User binaries
if [ -d "$HOME/bin" ]; then
  export PATH="$PATH:$HOME/bin"
fi
if [ -d "$HOME/.local/bin" ]; then
  export PATH="$PATH:$HOME/.local/bin"
fi
# Cargo
if [ -d "$HOME/.cargo" ]; then
  export PATH="$PATH:$HOME/.cargo/bin"
fi
# Deno
if [ -d "$DENO_INSTALL/bin" ]; then
  export PATH="$DENO_INSTALL/bin:$PATH"
fi
# Poetry
if [ -d "$HOME/.poetry" ]; then
  export PATH="$HOME/.poetry/bin:$PATH"
fi
# Wezterm
if [ -d "/Applications/Wezterm.app/Contents/MacOS" ]; then
  export PATH="$PATH:/Applications/Wezterm.app/Contents/MacOS"
fi
# Kitty
if [ -d "/Applications/kitty.app/Contents/MacOS" ]; then
  export PATH="$PATH:/Applications/kitty.app/Contents/MacOS"
fi
# Neovim
if [ -d "$HOME/.local/share/neovim/bin" ]; then
  export PATH="$PATH:$HOME/.local/share/neovim/bin"
fi


## ======================
## Oh My Zsh finalization
## ======================
# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh
# Load Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

## ================
## Aliases override
## ================
# Dotfiles using git
if [ -d "$HOME/.dotfiles" ]; then
  alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
  alias gitd='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
fi
# Exa
if [ -x "$(command -v exa)" ]; then
  alias ls='exa'
  alias lsa='exa -a'
  alias l='exa -l'
  alias la='exa -la'
fi
# Trash
if [ -x "$(command -v trash)" ]; then
  alias trash='trash -F'
fi

## ================
## System variables
## ================
# SSH
export SSH_AUTH_SOCK=~/.1password/agent.sock
# Editor
if [ -x "$(command -v nvim)" ]; then
  export EDITOR="nvim"
  export VISUAL="nvim"
fi
# Man pages
if [ -x "$(command -v nvim)" ]; then
  export MANPAGER="nvim +Man!"
fi

## ====================
## SDK!Man finalization
## ====================
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
