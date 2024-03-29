## ==============
## Initialization
## ==============
# Use Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# Remove soft limit for the number of simultaneously opened files when using MacOS
if [[ $(uname) == "Darwin" ]]; then
  ulimit -n unlimited
fi

## ============================
## Configure zsh-vi-mode plugin
## ============================
function zvm_config() {
  # Use s-prefix mode
  ZVM_VI_SURROUND_BINDKEY=s-prefix
  # Use neovim as editor
  ZVM_VI_EDITOR=nvim
}
# Add FZF keybinds
zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')

## =======================
## Aesthetic configuration
## =======================
# Better LS_COLORS
export LS_COLORS="$LS_COLORS:ow=1;7;34:st=30;44:su=30;41"
# Change theme
ZSH_THEME="powerlevel10k/powerlevel10k"
# Make FZF use rose-pine as theme
export FZF_DEFAULT_OPTS="
  --color=fg:#908caa,bg:#191724,hl:#ebbcba
  --color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
  --color=border:#403d52,header:#31748f,gutter:#191724
  --color=spinner:#f6c177,info:#9ccfd8,separator:#403d52
  --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

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
  # Use <Up> and <Down> to search on history
  bindkey '^[[A' up-line-or-beginning-search # <Up>
  bindkey '^[[B' down-line-or-beginning-search # <Down>
  # Fix <Home> and <End>
  bindkey '^[[1~' beginning-of-line
  bindkey '^[[4~' end-of-line
  # Set MacOS shortcuts
  bindkey '^[[1;3D' backward-word # ⌥+<Left>
  bindkey '^[[1;3C' forward-word # ⌥+<Right>
  # Edit command line with <C-f>
  bindkey '^F' edit-command-line
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
  1password
  aws
  deno
  fd
  fzf
  npm
  kubectl
  bun
  # -- Custom plugins --
  zsh-vi-mode
  fast-syntax-highlighting
)

## ====================
## Binary configuration
## ====================
# Homebrew
if [ -d "/opt/homebrew" ]; then
  # For MacOS
  eval $(/opt/homebrew/bin/brew shellenv)
elif [ -d "/home/linuxbrew/.linuxbrew" ]; then
  # For Linux
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi
if [ -x "$(command -v brew)" ]; then
  # Add C libraries installed with brew
  export CPATH="$CPATH:$(brew --prefix)/include"
  export LIBRARY_PATH="$LIBRARY_PATH:$(brew --prefix)/lib"
  export LDFLAGS="-L$(brew --prefix)/opt/openssl@3/lib"
  export CPPFLAGS="-I$(brew --prefix)/opt/openssl@3/include"
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
# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude '.git' --exclude 'node_modules'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"
_fzf_compgen_path() {
  fd . "$1"
}
_fzf_compgen_dir() {
  fd --type d . "$1"
}
# OPAM
[[ ! -r $HOME/.opam/opam-init/init.zsh ]] || \
  source $HOME/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
# 1Password CLI
if [ -x "$HOME/.config/op/plugins.sh" ]; then
  source $HOME/.config/op/plugins.sh
fi
# zoxide
if [ -x "$(command -v zoxide)" ]; then
  eval "$(zoxide init --cmd cd zsh)"
fi

## ==============
## User variables
## ==============
export NVIM="${XDG_CONFIG_HOME:-$HOME/.config}/${NVIM_APPNAME:-nvim}"

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
# bun
if [ -d "$HOME/.bun" ]; then
  export BUN_INSTALL="$HOME/.bun"
fi

## =============
## PATH variable
## =============
# User scripts
if [ -d "$HOME/scripts" ]; then
  export PATH="$PATH:$HOME/scripts"
fi
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
if [ ! -z $DENO_INSTALL ] && [ -d "$DENO_INSTALL/bin" ]; then
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
# Doom Emacs
if [ -d "$HOME/.emacs.d/bin" ]; then
  export PATH="$PATH:$HOME/.emacs.d/bin"
fi
# Neovide
if [ -d "/Applications/Neovide.app/Contents/MacOS" ]; then
  export PATH="$PATH:/Applications/Neovide.app/Contents/MacOS"
fi
# LLVM
if [ -x "$(command -v brew)" ] && [ -d "$(brew --prefix)/opt/llvm/bin" ]; then
  export PATH="$PATH:$(brew --prefix)/opt/llvm/bin"
fi
# Bob (Neovim)
if [ -d "$HOME/.local/share/bob/nvim-bin" ]; then
  export PATH="$PATH:$HOME/.local/share/bob/nvim-bin"
fi
# GHCup (Haskell)
if [ -d "$HOME/.ghcup/bin" ]; then
  export PATH="$PATH:$HOME/.ghcup/bin"
fi
# Cabal (Haskell)
if [ -d "$HOME/.cabal/bin" ]; then
  export PATH="$PATH:$HOME/.cabal/bin"
fi
# bun
if [ ! -z $BUN_INSTALL ] && [ -d "$BUN_INSTALL/bin" ]; then
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

## ========================
## Completion configuration
## ========================
# Add custom completions
fpath+=$HOME/.zfunc
# Add homebrew completions
fpath+=$HOMEBREW_PREFIX/share/zsh/site-functions
# Add zsh-completions plugin
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

## ======================
## Oh My Zsh finalization
## ======================
# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh
# Load Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

## =======
## Aliases
## =======
source ~/.aliases.sh

## ================
## System variables
## ================
# Editor
if [ -x "$(command -v nvim)" ]; then
  export EDITOR=$(command -v nvim)
  export VISUAL=$(command -v nvim)
fi
# Man pages
if [ -x "$(command -v nvim)" ]; then
  export MANPAGER="nvim +Man!"
fi
# Locale
export LANG=en_US.UTF-8
# TERMINFO
export TERMINFO_DIRS=$TERMINFO_DIRS:$HOME/.local/share/terminfo

## ====================
## SDK!Man finalization
## ====================
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
