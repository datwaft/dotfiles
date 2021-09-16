# ===========================
# .PROFILE CONFIGURATION FILE
# ===========================
# Created by datwaft <github.com/datwaft>

# =======
# Aliases
# =======
  # --------
  # Dotfiles
  # --------
    alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
  # --------
  # LSDeluxe
  # --------
    if [ -x "$(command -v lsd)" ]; then
      alias ls='lsd'
      alias l='lsd -l'
      alias lsa='lsd -A'
      alias la='lsd -l -A'
    fi
  # --------
  # Explorer
  # --------
    alias explorer='/mnt/c/Windows/explorer.exe'
  # -----------
  # Windows CMD
  # -----------
    alias cmd='/mnt/c/Windows/System32/cmd.exe /c'
  # ---------
  # Win32Yank
  # ---------
    if [ -x "$(command -v win32yank.exe)" ]; then
      alias yank='win32yank.exe -i'
      alias put='win32yank.exe -o'
    fi
  # ----------
  # SumatraPDF
  # ----------
    if [ -d "/mnt/c/Users/David/AppData/Local/SumatraPDF" ] ; then
      alias SumatraPDF='/mnt/c/Users/David/AppData/Local/SumatraPDF/SumatraPDF.exe'
    fi
  # ------
  # Chrome
  # ------
    if [ -d "/mnt/c/Program Files/Google/Chrome" ] ; then
      alias chrome='"/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"'
    fi
# ================
# System variables
# ================
  # ----
  # Term
  # ----
    export TERM='tmux-256color'
  # -------
  # Display
  # -------
    export DISPLAY="$(/sbin/ip route | awk '/default/{ print $3 }'):0"
  # ------
  # Editor
  # ------
    if [ -x "$(command -v nvim)" ]; then
      export EDITOR='nvim'
      export VISUAL='nvim'
    else
      export EDITOR='vim'
      export VISUAL='vim'
    fi
  # ---------
  # Man pages
  # ---------
    if [ -x "$(command -v nvim)" ]; then
      export MANPAGER='nvim +Man!'
    else
      export MANPAGER='vim +Man!'
    fi
# ==============
# User variables
# ==============
  # ---------------------
  # Neovim home directory
  # ---------------------
    export NVIM="$HOME/.config/nvim.main"
# ==================
# Binaries variables
# ==================
  # ----
  # Java
  # ----
    if [ -d "/usr/lib/jvm/java-16-oracle" ] ; then
      export JAVA_HOME="/usr/lib/jvm/java-16-oracle"
    fi
  # ------
  # Gradle
  # ------
    if [ -d "/opt/gradle/gradle-6.7" ] ; then
      export GRADLE_HOME="/opt/gradle/gradle-6.7"
    fi
  # ----
  # Deno
  # ----
    if [ -d "$HOME/.deno" ] ; then
      export DENO_INSTALL="$HOME/.deno"
    fi
  # ------
  # Goland
  # ------
    if [ -d "$HOME/go" ] ; then
      export GOPATH="$HOME/go"
    fi
    if [ -d "/usr/local/opt/go/libexec" ] ; then
      export GOROOT="/usr/local/opt/go/libexec"
    fi
# =============
# PATH variable
# =============
  # ---------------
  # System binaries
  # ---------------
    if [ -d "/usr/local/bin" ] ; then
      export PATH="$PATH:/usr/local/bin"
    fi
  # -------------
  # User binaries
  # -------------
    if [ -d "$HOME/bin" ] ; then
      export PATH="$HOME/bin:$PATH"
    fi
    if [ -d "$HOME/.local/bin" ] ; then
      export PATH="$HOME/.local/bin:$PATH"
    fi
  # ------
  # Python
  # ------
    if [ -d "/home/linuxbrew/.linuxbrew/opt/python@3.9/libexec/bin" ] ; then
      export PATH="/home/linuxbrew/.linuxbrew/opt/python@3.9/libexec/bin:$PATH"
    fi
  # ----
  # Java
  # ----
    if [ -d "$JAVA_HOME" ] ; then
      export PATH="$PATH:$JAVA_HOME/bin"
    fi
  # ------
  # Gradle
  # ------
    if [ -d "$GRADLE_HOME/bin" ] ; then
      export PATH="$PATH:$GRADLE_HOME/bin"
    fi
  # -----
  # Cargo
  # -----
    if [ -d "$HOME/.cargo/bin" ] ; then
      export PATH="$PATH:$HOME/.cargo/bin"
    fi
  # ----
  # Deno
  # ----
    if [ -d "$DENO_INSTALL/bin" ] ; then
      export PATH="$DENO_INSTALL/bin:$PATH"
    fi
  # ------
  # Golang
  # ------
    if [ -d "$GOPATH/bin" ] ; then
      export PATH="$PATH:$GOPATH/bin"
    fi
    if [ -d "$GOROOT/bin" ] ; then
      export PATH="$PATH:$GOROOT/bin"
    fi
  # -------------------
  # Lua Language Server
  # -------------------
    if [ -d "$HOME/.local/bin/lua-language-server/bin/Linux" ] ; then
      export PATH="$PATH:$HOME/.local/bin/lua-language-server/bin/Linux"
    fi
# ======================
# Binaries configuration
# ======================
  # --------
  # Homebrew
  # --------
    if [ -d "/home/linuxbrew/" ] ; then
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
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  # ---
  # FZF
  # ---
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
  # ------------------
  # Go Version Manager
  # ------------------
    [[ -s "/home/datwaft/.gvm/scripts/gvm" ]] && source "/home/datwaft/.gvm/scripts/gvm"
  # ---------
  # Prettierd
  # ---------
    export PRETTIERD_DEFAULT_CONFIG="$HOME/.prettierrc.json"
# ===============
# Theme variables
# ===============
  export FOREGROUND_COLOR="#abb2bf"
  export BACKGROUND_COLOR="#0e171e"
  export BLACK_COLOR="#393b44"
  export RED_COLOR="#c94f6d"
  export GREEN_COLOR="#97c374"
  export YELLOW_COLOR="#dbc074"
  export BLUE_COLOR="#61afef"
  export MAGENTA_COLOR="#c678dd"
  export CYAN_COLOR="#63cdcf"
  export WHITE_COLOR="#dfdfe0"
