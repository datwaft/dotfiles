# =========================
# .ZSHRC CONFIGURATION FILE
# =========================
# Created by datwaft <github.com/datwaft>

# ===================
# Start configuration
# ===================
  # ---------------
  # Start with tmux
  # ---------------
    if [ "$TMUX" = "" ]; then
      exec tmux new-session -A -s default
    fi 
  # ----------------------------
  # Powerlevel10k instant prompt
  # ----------------------------
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
      source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
# =======================
# Aesthetic configuration
# =======================
  # --------
  # LSCOLORS
  # --------
    . "$HOME/.local/share/lscolors.sh"
# =========
# Oh My Zsh
# =========
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
  # Autosuggestions
  ZSH_AUTOSUGGEST_STRATEGY="completion"
  ZSH_AUTOSUGGEST_USE_ASYNC="true"
# ==================
# Plugins -> Antigen
# ==================
  # --------------
  # Initialization
  # --------------
    source "$HOME/.zsh/antigen.zsh"
  # -------
  # Plugins
  # -------
    antigen use oh-my-zsh
    antigen bundle git
    antigen bundle heroku
    antigen bundle pip
    antigen bundle lein
    antigen bundle command-not-found
    antigen bundle zsh-users/zsh-syntax-highlighting
    antigen bundle zsh-users/zsh-autosuggestions
    # Powerlevel10k
    antigen theme romkatv/powerlevel10k
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
  # ------------
  # Finalization
  # ------------
    antigen apply
# =====================
# Vi mode configuration
# =====================
  # -----------
  # Set vi mode
  # -----------
    set -o vi
  # ------------------------
  # Configure vi mode cursor
  # ------------------------
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
  # Enable editting of commands
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
# ============
# Finalization
# ============
  source "$HOME/.profile"
