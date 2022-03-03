# .ZSHRC
# ======

# =====================
# Startup configuration
# =====================
  # -----------------
  # Start within tmux
  # -----------------
    if [ -x "$(command -v tmux)" ]; then
      export TERM="tmux-256color"
      if [[ "$TERM_PROGRAM" == 'vscode' ]]; then
        exec tmux new-session -A -s "[vs] $(pwd | md5sum | awk '{print $1}')"
      elif [ ! -n "$TMUX" ]; then
        exec tmux new-session -A -s default
      fi
    fi
  # --------------
  # Instant prompt
  # --------------
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
      source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi

# =======================
# Aesthetic configuration
# =======================
  # --------
  # LSCOLORS
  # --------
  if [ -s "$HOME/.local/share/lscolors.sh" ]; then
    source "$HOME/.local/share/lscolors.sh"
  fi

# =========
# Oh My Zsh
# =========
  # Initialization
  export ZSH="$HOME/.oh-my-zsh"
  # Case insensitive completion
  CASE_SENSITIVE="false"
  # Hyphen insensitive completion
  HYPHEN_INSENSITIVE="true"
  # Display red dots whilst waiting for completion
  COMPLETION_WAITING_DOTS="true"
  # Faster status check - not marking untracked files as dirty
  DISABLE_UNTRACKED_FILES_DIRTY="true"
  # Time stamp
  HIST_STAMPS="yyyy-mm-dd"
  # Autosuggestions
  ZSH_AUTOSUGGEST_STRATEGY="completion"
  ZSH_AUTOSUGGEST_USE_ASYNC="true"

# =======
# Plugins
# =======
  # -------
  # Listing
  # -------
    if [ -s "$HOME/.zsh/antigen.zsh" ]; then
      source "$HOME/.zsh/antigen.zsh"
      antigen use oh-my-zsh
      antigen bundle git
      antigen bundle heroku
      antigen bundle pip
      antigen bundle lein
      antigen bundle command-not-found
      antigen bundle web-search
      antigen bundle zsh-users/zsh-syntax-highlighting
      antigen bundle zsh-users/zsh-completions
      antigen bundle zsh-users/zsh-autosuggestions
      antigen theme romkatv/powerlevel10k
      antigen apply
    else
      echo "Antigen not found."
      echo "Please install using: curl -L git.io/antigen > ~/.zsh/antigen.zsh"
    fi
  # -----
  # Theme
  # -----
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ===================
# Conda configuration
# ===================
  __conda_setup="$("$HOME/.local/bin/miniconda/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "$HOME/.local/bin/miniconda/etc/profile.d/conda.sh" ]; then
          . "$HOME/.local/bin/miniconda/etc/profile.d/conda.sh"
      else
          export PATH="$HOME/.local/bin/miniconda/bin:$PATH"
      fi
  fi
  unset __conda_setup

# ====================
# direnv configuration
# ====================
  if [ -n "$(command -v direnv)" ]; then
    eval "$(direnv hook zsh)"
  fi

# ===================
# Pyenv configuration
# ===================
  if [ -n "$(command -v pyenv)" ]; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  fi

# ===================
# Broot configuration
# ===================
  if [ -n "$(command -v broot)" ]; then
    source $HOME/.config/broot/launcher/bash/br
  fi

# =================
# GPG configuration
# =================
  export GPG_TTY=$TTY

# ======================
# VIM-mode configuration
# ======================
  set -o vi
  # --------------------
  # Cursor configuration
  # --------------------
    # Change cursor depending on mode
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

# =====================
# History configuration
# =====================
  # Where to save history
  export HISTFILE=~/.zsh_history
  # Size of the history
  export HISTFILESIZE=1000000000
  export HISTSIZE=1000000000
  export SAVEHIST=1000000000
  # Add timestamp to the history
  export HISTTIMEFORMAT="[%y-%m-%d %T] "
  setopt EXTENDED_HISTORY
  # History is shared between sessions
  setopt SHARE_HISTORY
  # Not show duplicates
  setopt HIST_FIND_NO_DUPS
  # Not write duplicates
  setopt HIST_IGNORE_ALL_DUPS

# ======================
# Keyboard configuration
# ======================
  # Ability to travel the menu backwards
  bindkey '^[[Z' reverse-menu-complete
  # Accept autosuggestions
  bindkey '^ ' autosuggest-accept
  # Enable editing of commands
  autoload -U edit-command-line
  zle -N edit-command-line
  bindkey -M vicmd v edit-command-line
  # Use up and down arrows to search on history
  autoload -U up-line-or-beginning-search
  autoload -U down-line-or-beginning-search
  zle -N up-line-or-beginning-search
  zle -N down-line-or-beginning-search
  bindkey '^[[A' up-line-or-beginning-search # Up
  bindkey '^[[B' down-line-or-beginning-search # Down

# ===========================
# Miscellaneous configuration
# ===========================
  # Disable bell
  unsetopt BEEP
