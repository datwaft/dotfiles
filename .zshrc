# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                                           oooo                                               ║ #
# ║                                           `888                                               ║ #
# ║                         oooooooo  .oooo.o  888 .oo.   oooo d8b  .ooooo.                      ║ #
# ║                        d'""7d8P  d88(  "8  888P"Y88b  `888""8P d88' `"Y8                     ║ #
# ║                          .d8P'   `"Y88b.   888   888   888     888                           ║ #
# ║                   .o.  .d8P'  .P o.  )88b  888   888   888     888   .o8                     ║ #
# ║                   Y8P d8888888P  8""888P' o888o o888o d888b    `Y8bod8P'                     ║ #
# ║                                                                                              ║ #
# ║                                      Created by datwaft                                      ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #

# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                                    Previus Initialization                                    ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #
  # Begin with tmux
  if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    exec tmux
  fi
# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                                      Aliases Definition                                      ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #
  # dotfiles alias
  alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
  # vim-like aliases
  alias :e='nvim'
  alias :q='exit'
  # figlet alias
  alias banner='figlet -d ~/.fonts -f roman -w 100'
  # ls
  alias ls='ls --color=auto'
# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                                            ZINIT                                             ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #
  # ┌────────────────────────────────────────────────────────────────────────────────────────────┐ #
  # │                                       Initialization                                       │ #
  # └────────────────────────────────────────────────────────────────────────────────────────────┘ #
    # +------------------------------------------------------------------------------------------+ #
    # |                                          ZINIT                                           | #
    # +------------------------------------------------------------------------------------------+ #
      if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
          print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
          command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
          command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
              print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
              print -P "%F{160}▓▒░ The clone has failed.%f%b"
      fi

      source "$HOME/.zinit/bin/zinit.zsh"
      autoload -Uz _zinit
      (( ${+_comps} )) && _comps[zinit]=_zinit

      # Load a few important annexes, without Turbo
      # (this is currently required for annexes)
      zinit light-mode for \
          zinit-zsh/z-a-rust \
          zinit-zsh/z-a-as-monitor \
          zinit-zsh/z-a-patch-dl \
          zinit-zsh/z-a-bin-gem-node
    # +------------------------------------------------------------------------------------------+ #
    # |                                        Oh My Zsh                                         | #
    # +------------------------------------------------------------------------------------------+ #
      # Load OMZ Git library
      zinit snippet OMZL::git.zsh

      # Load Git plugin from OMZ
      zinit snippet OMZP::git
      zinit cdclear -q # <- forget completions provided up to this moment

      setopt promptsubst
  # ┌────────────────────────────────────────────────────────────────────────────────────────────┐ #
  # │                                          Plugins                                           │ #
  # └────────────────────────────────────────────────────────────────────────────────────────────┘ #
    # Autosuggestions
    zinit light zsh-users/zsh-autosuggestions
    # Syntax highlighting
    zinit wait lucid for \
     atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        zdharma/fast-syntax-highlighting \
     blockf \
        zsh-users/zsh-completions \
     atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions
  # ┌────────────────────────────────────────────────────────────────────────────────────────────┐ #
  # │                                           Theme                                            │ #
  # └────────────────────────────────────────────────────────────────────────────────────────────┘ #
    # Powerlevel10k
    zinit ice depth=1; zinit light romkatv/powerlevel10k
    # Configuration
    # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
  # ┌────────────────────────────────────────────────────────────────────────────────────────────┐ #
  # │                                        Colorscheme                                         │ #
  # └────────────────────────────────────────────────────────────────────────────────────────────┘ #
    [ -n "$PS1" ] && sh ~/.config/nvim/plugged/snow/shell/snow_dark.sh
    eval `dircolors ~/.config/nvim/plugged/snow/shell/dircolors`
# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                                      ZSH Configuration                                       ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #
  # ┌────────────────────────────────────────────────────────────────────────────────────────────┐ #
  # │                                          Plugins                                           │ #
  # └────────────────────────────────────────────────────────────────────────────────────────────┘ #
    plugins=(
      git
      zsh-syntax-highlighting
      zsh-autosuggestions
    )
  # ┌────────────────────────────────────────────────────────────────────────────────────────────┐ #
  # │                                       Configuration                                        │ #
  # └────────────────────────────────────────────────────────────────────────────────────────────┘ #
    # Changing the date format
    HIST_STAMPS="yyyy-mm-dd"
    # Better alias autocompletion
    setopt completealiases
# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                                      User Configuration                                      ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #
  # Default editor
  export EDITOR='nvim'
  export VISUAL="$EDITOR"
  # Vi console mode
  set -o vi
  # Using neovim as manpager
  export MANPAGER='nvim +Man!'
  # Display for WSL
  export DISPLAY=$(/sbin/ip route | awk '/default/ { print $3 }'):0
# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                                    Keyboard Configuration                                    ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #
  # Ability to travel the menu backwards
  bindkey '^[[Z' reverse-menu-complete
# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                                Program-specific Configuration                                ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #
  # ┌────────────────────────────────────────────────────────────────────────────────────────────┐ #
  # │                                            NVM                                             │ #
  # └────────────────────────────────────────────────────────────────────────────────────────────┘ #
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
