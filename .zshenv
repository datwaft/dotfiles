# .ZSHENV
# =======

# ================
# System variables
# ================
  # -------
  # Display
  # -------
    export DISPLAY="$(/sbin/ip route | awk '/default/{ print $3 }'):0"
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

# =====================
# Environment variables
# =====================
  export WINOS="/mnt/c"
  export WINDATA="/mnt/d"

# ==============
# User variables
# ==============
  export NVIM="$HOME/.config/nvim.main"

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

# ==================
# Binaries variables
# ==================
  # --------------------
  # Node Version Manager
  # --------------------
    if [ -d "$HOME/.nvm" ]; then
      export NVM_DIR="$HOME/.nvm"
    fi
  # ---------
  # Prettierd
  # ---------
    export PRETTIERD_DEFAULT_CONFIG="$HOME/.prettierrc.json"

# ======================
# Binaries configuration
# ======================
  # --------
  # Homebrew
  # --------
    if [ -d "/home/linuxbrew" ]; then
      eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    fi
  # -----
  # Cargo
  # -----
    if [ -d "$HOME/.cargo" ] ; then
      source "$HOME/.cargo/env"
    fi
  # --------------------
  # Node Version Manager
  # --------------------
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
  # ------------------
  # Go Version Manager
  # ------------------
    [ -s "$HOME/.gvm/scripts/gvm" ] && source "$HOME/.gvm/scripts/gvm"

# =======
# Aliases
# =======
  # ------------------
  # Dotfiles using git
  # ------------------
    if [ -d "$HOME/.dotfiles" ]; then
      alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    fi
  # ----------------
  # Windows Explorer
  # ----------------
    if [ -x "$WINOS/Windows/explorer.exe" ]; then
      alias explorer="$WINOS/Windows/explorer.exe"
    fi
  # -----------
  # Windows CMD
  # -----------
    if [ -x "$WINOS/Windows/System32/cmd.exe" ]; then
      alias cmd="$WINOS/Windows/System32/cmd.exe /c"
    fi
  # ---------
  # Win32Yank
  # ---------
    if [ -x "$(command -v win32yank.exe)" ]; then
      alias yank="win32yank.exe -i"
      alias put="win32yank.exe -o"
    fi
  # --------
  # LSDeluxe
  # --------
    if [ -x "$(command -v lsd)" ]; then
      alias ls='lsd'
      alias l='lsd -l'
      alias lsa='lsd -A'
      alias la='lsd -l -A'
    else
      alias l='ls -l'
      alias lsa='ls -A'
      alias la='ls -l -A'
    fi
