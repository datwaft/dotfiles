# ==================
# FISH CONFIGURATION
# ==================
# Created by: datwaft [github.com/datwaft]

# =====================
# Startup configuration
# =====================
  # Start tmux at startup
  if status is-interactive
  and not set -q TMUX
    exec tmux new-session -A -s default
  end
# =======
# Aliases
# =======
  # dotfiles alias
  function dotfiles
    /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" $argv
  end
  function cmd
    /mnt/c/Windows/System32/cmd.exe /c $argv
  end
  function explorer
    /mnt/c/Windows/explorer.exe $argv
  end
  function SumatraPDF
    /mnt/c/Users/David/AppData/Local/SumatraPDF/SumatraPDF.exe $argv
  end
  function swipl
    zsh -c "swipl $argv"
  end
# ===============
# Shell variables
# ===============
  # Configuration variables
  # =======================
    # Colors
    set -x TERM "alacritty"
    # Default editor
    set -x EDITOR "nvim"
    set -x VISUAL "$EDITOR"
    # Man pager
    set -x MANPAGER "nvim +Man!"
    # Display
    set -x DISPLAY (/sbin/ip route | awk '/default/ { print $3 }')":0"
  # PATH declaration
  # ================
    set -x PATH $PATH /usr/local/bin
    # Initial
    set -x PATH $PATH /usr/local/bin
    set -x PATH $PATH $HOME/bin
    set -x PATH $PATH $HOME/.local/bin
    # Scripts
    set -x PATH $PATH $HOME/.scripts/
    # Go instalation
    set -x PATH $PATH /usr/local/share/go/bin
    # Gradle
    set -x PATH $PATH /opt/gradle/gradle-6.7/bin
    # TexLive
    set -x PATH /usr/local/texlive/2020/bin/x86_64-linux $PATH
  # Miscelaneous variables
  # ======================
    # Vim
    set -x NVIM $HOME/.config/nvim
    # Java
    set -x JAVA_HOME /usr/lib/jvm/java-14-oracle
    set -x PATH $PATH $JAVA_HOME/bin
    # Gradle
    set -x GRADLE_HOME /opt/gradle/gradle-6.7/
    # OpenSSL
    set -x OPENSSL_CONF /tmp/openssl.cnf
    # Update MANPATH
    set -x MANPATH /usr/local/man $MANPATH
    set -x MANPATH /usr/local/texlive/2020/texmf-dist/doc/man $MANPATH
    # Update INFOPATH
    set -x INFOPATH /usr/local/texlive/2020/texmf-dist/doc/info $INFOPATH
# =======================
# Aesthetic configuration
# =======================
  # Greeting
  function fish_greeting
    printf "Welcome back, "
    set_color --italics --bold yellow
    printf $USER
    set_color normal
    printf "."
    echo
  end
  # LS COlORS
  source ~/.config/fish/lscolors.fish
  # Change cursor in Vi mode
  set fish_vi_force_cursor
  set fish_cursor_default     block      blink
  set fish_cursor_insert      line       blink
  set fish_cursor_replace_one underscore blink
  set fish_cursor_visual      block
  # BobTheFish theme configuration
  set -g theme_nerd_fonts yes
  set -g theme_display_virtualenv no
# ===========
# Keybindings
# ===========
  # Use space key to accept completion
  bind -M insert " " space_or_accept_completion
  # Use Vi keybindings
  function fish_user_key_bindings
    fish_vi_key_bindings
  end
# =====================
# Function declarations
# =====================
  # Auxiliar function to use space key to accept completion
  function space_or_accept_completion
    if commandline -P
      commandline -f execute
    else
      commandline -i " "
    end
  end
# ============
# Finalization
# ============
  # Conda
  eval /usr/local/share/anaconda/bin/conda "shell.fish" "hook" $argv | source
  # Startship
  starship init fish | source
