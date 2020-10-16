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
    exec tmux new-session -A -s default
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
# ║                                        Initialization                                        ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #
  # Powerlevel10k instant prompt
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
  # LS_COLORS
  . "$HOME/.local/share/lscolors.sh"
# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                                          Oh My Zsh                                           ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #
  # Initilization
  export ZSH="$HOME/.oh-my-zsh"
  # Case insentive completion
  CASE_SENSITIVE="false"
  # Hypen insensitive completion
  HYPHEN_INSENSITIVE="true"
  # Display red dots whilst waiting for completion
  COMPLETION_WAITING_DOTS="true"
  # Faster status check - not marking untracked files as dirty
  DISABLE_UNTRACKED_FILES_DIRTY="true"
  # Time stamp
  HIST_STAMPS="yyyy-mm-dd"
# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                                      Plugins -> Antigen                                      ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #
  # Initilization
  source "$HOME/.zsh/antigen.zsh"

  # Use oh-my-zsh
  antigen use oh-my-zsh

  # Bundles from default repo
  antigen bundle git
  antigen bundle heroku
  antigen bundle pip
  antigen bundle lein
  antigen bundle command-not-found

  # Better completion
  antigen bundle zsh-users/zsh-completions

  # Syntax highlighting bundle.
  antigen bundle zsh-users/zsh-syntax-highlighting

  # Autosuggestions
  antigen bundle zsh-users/zsh-autosuggestions
  ZSH_AUTOSUGGEST_STRATEGY="completion"
  ZSH_AUTOSUGGEST_USE_ASYNC="true"

  # Theme
  antigen theme romkatv/powerlevel10k
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

  # Finishing
  antigen apply
# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                                      User Configuration                                      ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #
  # Colors
  export TERM="alacritty"
  # Default editor
  export EDITOR='nvim'
  export VISUAL="$EDITOR"
  # Vi console mode
  set -o vi
  # Vi mode cursor
  bindkey -v
  KEYTIMEOUT=5
  function zle-keymap-select {
    if [[ $KEYMAP == vicmd ]] || [[ $1 = 'block' ]]; then
      echo -ne '\e[1 q'
    elif [[ $KEYMAP == main ]] || [[ $KEYMAP == viins ]] || [[ $KEYMAP = '' ]] || [[ $1 = 'beam' ]]; then
      echo -ne '\e[5 q'
    fi
  }
  zle -N zle-keymap-select
  zle-line-init() { zle-keymap-select 'beam'}
  # Enable editting of commands
  autoload -U edit-command-line
  zle -N edit-command-line
  bindkey -M vicmd v edit-command-line
  # Using neovim as manpager
  export MANPAGER='nvim +Man!'
  # Display for WSL
  export DISPLAY=$(/sbin/ip route | awk '/default/ { print $3 }'):0
  # Save history
  HISTFILE=~/.zsh_history
  HISTSIZE=10000
  SAVEHIST=10000
  setopt appendhistory
# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                                    Keyboard Configuration                                    ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #
  # Ability to travel the menu backwards
  bindkey '^[[Z' reverse-menu-complete
  # Accept autosuggestions
  bindkey '^ ' autosuggest-accept
# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                                Program-specific Configuration                                ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #
  # ┌────────────────────────────────────────────────────────────────────────────────────────────┐ #
  # │                                            NVM                                             │ #
  # └────────────────────────────────────────────────────────────────────────────────────────────┘ #
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
