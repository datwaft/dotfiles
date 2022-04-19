# .ZSHENV
# =======

# ================
# System variables
# ================
  # ---
  # SSH
  # ---
    if grep -q WSL /proc/version; then
      export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
    else
      export SSH_AUTH_SOCK=~/.1password/agent.sock
    fi
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
  export NVIM="$HOME/.config/nvim.conf"

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
  # -------------------
  # Lua Language Server
  # -------------------
    if [ -d "$HOME/.local/bin/lua-language-server" ]; then
      export PATH="$PATH:$HOME/.local/bin/lua-language-server/bin/Linux"
    fi

# ==================
# Binaries variables
# ==================
  # ----
  # Java
  # ----
    if [ -x "$(command -v brew)" ] && [ -d "$(brew --prefix)/opt/java" ]; then
      export JAVA_HOME="$(brew --prefix)/opt/java"
    fi
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
  # -----
  # Pyenv
  # -----
    if [ -n "$(command -v pyenv)" ]; then
      eval "$(pyenv init --path)"
      export PYENV_VIRTUALENV_DISABLE_PROMPT=1
      export PYENV_ROOT="$(pyenv root)"
    fi

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
  # -------------
  # Google Chrome
  # -------------
    if [ -x "$WINOS/Program Files/Google/Chrome/Application/chrome.exe" ]; then
      alias chrome="$WINOS/Program\ Files/Google/Chrome/Application/chrome.exe"
    fi
  # ---------
  # Win32Yank
  # ---------
    if [ -x "$(command -v win32yank.exe)" ]; then
      alias yank="win32yank.exe -i"
      alias put="win32yank.exe -o"
    fi
