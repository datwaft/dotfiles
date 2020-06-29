# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                                      Aliases Definition                                      ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #
  # dotfiles alias
  alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
  # vim-like aliases
  alias :e='nvim'
  alias :q='exit'
# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                                    Environment Variables                                     ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #
  # Java home folder
  export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
  # OpenSSL
  export OPENSSL_CONF=/tmp/openssl.cnf
  # Update MANPATH
  export MANPATH=/usr/local/man:$MANPATH
  export MANPATH=/usr/local/texlive/2020/texmf-dist/doc/man:$MANPATH
  # Update INFOPATH
  export INFOPATH=/usr/local/texlive/2020/texmf-dist/doc/info:$INFOPATH
# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                                             PATH                                             ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #
  # Initial
  export PATH=$PATH:/usr/local/bin
  export PATH=$PATH:$HOME/bin
  export PATH=$PATH:$HOME/.local/bin
  # Go instalation
  export PATH=$PATH:/usr/local/go/bin
  # Java instalation
  export PATH=$PATH:$JAVA_HOME/bin
  # TexLive
  export PATH=$PATH:/usr/local/texlive/2020/bin/x86_64-linux
# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                                      ZSH Configuration                                       ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #
  # ┌────────────────────────────────────────────────────────────────────────────────────────────┐ #
  # │                                   Initial Configuration                                    │ #
  # └────────────────────────────────────────────────────────────────────────────────────────────┘ #
    # Pure initial configuration
    fpath+=$HOME/.zsh/pure
    export ZSH="$HOME/.oh-my-zsh"
  # ┌────────────────────────────────────────────────────────────────────────────────────────────┐ #
  # │                                        Colorscheme                                         │ #
  # └────────────────────────────────────────────────────────────────────────────────────────────┘ #
    [ -n "$PS1" ] && sh ~/.nightshell/carbonized-dark
    eval `dircolors ~/.nightshell/dircolors`
  # ┌────────────────────────────────────────────────────────────────────────────────────────────┐ #
  # │                                          Plugins                                           │ #
  # └────────────────────────────────────────────────────────────────────────────────────────────┘ #
    # Added the plugins:
    #   git
    #   zsh-syntax-highlightning
    plugins=(git zsh-syntax-highlighting)
    # Enabling oh-my-zsh
    source $ZSH/oh-my-zsh.sh
  # ┌────────────────────────────────────────────────────────────────────────────────────────────┐ #
  # │                                           Theme                                            │ #
  # └────────────────────────────────────────────────────────────────────────────────────────────┘ #
    # Disabling default theme
    ZSH_THEME=""
    # Initializing Pure Theme
    autoload -U promptinit; promptinit
    # Showing git status as part of prompt
    zstyle :prompt:pure:git:stash show yes
    # Enabling Pure Theme
    prompt pure
  # ┌────────────────────────────────────────────────────────────────────────────────────────────┐ #
  # │                                       Configuration                                        │ #
  # └────────────────────────────────────────────────────────────────────────────────────────────┘ #
    # Changing the date format
    HIST_STAMPS="yyyy-mm-dd"
# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                                      User Configuration                                      ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #
  # Default editor
  export EDITOR='nvim'
  # Vi console mode
  set -o vi
  # Using neovim as manpager
  export MANPAGER='nvim +Man!'
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
