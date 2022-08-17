# .ZSHENV
# =======

# ================
# System variables
# ================
  # ---
  # SSH
  # ---
    export SSH_AUTH_SOCK=~/.1password/agent.sock
  # ------
  # Editor
  # ------
    if [ -x "$(command -v nvim)" ]; then
      export EDITOR="nvim"
      export VISUAL="nvim"
    fi
  # ---------
  # Man pages
  # ---------
    if [ -x "$(command -v nvim)" ]; then
      export MANPAGER="nvim +Man!"
    fi

# ==============
# User variables
# ==============
  export NVIM="$HOME/.config/nvim.conf"

# ==================
# Binaries variables
# ==================
  # ----
  # Java
  # ----
    if [ -x "$(command -v brew)" ] && [ -d "$(brew --prefix)/opt/java" ]; then
      export JAVA_HOME="$(brew --prefix)/opt/java"
    fi
  # ---------
  # Prettierd
  # ---------
    export PRETTIERD_DEFAULT_CONFIG="$HOME/.prettierrc.json"
  # ----
  # Deno
  # ----
    if [ -d "$HOME/.deno" ]; then
      export DENO_INSTALL="$HOME/.deno"
    fi

# =============
# PATH variable
# =============
  # -------------
  # User binaries
  # -------------
    if [ -d "$HOME/bin" ]; then
      export PATH="$PATH:$HOME/bin"
    fi
    if [ -d "$HOME/.local/bin" ]; then
      export PATH="$PATH:$HOME/.local/bin"
    fi
  # -----
  # Cargo
  # -----
    if [ -d "$HOME/.cargo" ]; then
      export PATH="$PATH:$HOME/.cargo/bin"
    fi
  # ----
  # Deno
  # ----
    if [ -d "$DENO_INSTALL/bin" ]; then
      export PATH="$DENO_INSTALL/bin:$PATH"
    fi
  # ------
  # Poetry
  # ------
    if [ -d "$HOME/.poetry" ]; then
      export PATH="$HOME/.poetry/bin:$PATH"
    fi

# ======================
# Binaries configuration
# ======================
  # --------
  # Homebrew
  # --------
    if [ -d "/home/linuxbrew" ]; then
      eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    elif [ -d "/opt/homebrew" ]; then
      eval $(/opt/homebrew/bin/brew shellenv)
    fi
  # -----
  # Cargo
  # -----
    if [ -d "$HOME/.cargo" ] ; then
      source "$HOME/.cargo/env"
    fi
  # -------
  # AWS CLI
  # -------
    export AWS_PROFILE=dguevara-littera-prod-qa

# =======
# Aliases
# =======
  # ------------------
  # Dotfiles using git
  # ------------------
    if [ -d "$HOME/.dotfiles" ]; then
      alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
      alias gitd='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
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
