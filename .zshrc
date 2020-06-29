# ┌──────────────────────────────────────────────────────────────────────────┐ #
# │                          Initial Configuration                           │ #
# └──────────────────────────────────────────────────────────────────────────┘ #
  # Dotfiles alias
  alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
  # Initialize environment variables
  export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
  export OPENSSL_CONF="/tmp/openssl.cnf"
  # Changing PATH
  export PATH=$HOME/bin:/usr/local/bin:$PATH
  export PATH=$PATH:~/.local/bin
  export PATH=$PATH:/usr/local/go/bin
  export PATH=$JAVA_HOME/bin:$PATH
  export PATH=/usr/local/texlive/2020/bin/x86_64-linux:$PATH
  # Adding to FPATH
  fpath+=$HOME/.zsh/pure
  # Path to your oh-my-zsh installation.
  export ZSH="/home/datwaft/.oh-my-zsh"
# ┌──────────────────────────────────────────────────────────────────────────┐ #
# │                               Colorscheme                                │ #
# └──────────────────────────────────────────────────────────────────────────┘ #
  [ -n "$PS1" ] && sh ~/.nightshell/carbonized-dark
  eval `dircolors ~/.nightshell/dircolors`
# ┌──────────────────────────────────────────────────────────────────────────┐ #
# │                                  Themes                                  │ #
# └──────────────────────────────────────────────────────────────────────────┘ #
  ZSH_THEME=""
# ┌──────────────────────────────────────────────────────────────────────────┐ #
# │                              Configuration                               │ #
# └──────────────────────────────────────────────────────────────────────────┘ #
  # Changing the date format
  HIST_STAMPS="yyyy-mm-dd"
# ┌──────────────────────────────────────────────────────────────────────────┐ #
# │                                 Plugins                                  │ #
# └──────────────────────────────────────────────────────────────────────────┘ #
  plugins=(git zsh-syntax-highlighting)
# ──────────────────────────────────────────────────────────────────────────── #
  source $ZSH/oh-my-zsh.sh
# ┌──────────────────────────────────────────────────────────────────────────┐ #
# │                              Themes (Pure)                               │ #
# └──────────────────────────────────────────────────────────────────────────┘ #
  # Initializing Pure Theme
  autoload -U promptinit; promptinit
  # Showing git status as part of prompt
  zstyle :prompt:pure:git:stash show yes
  # Enabling Pure Theme
  prompt pure
# ┌──────────────────────────────────────────────────────────────────────────┐ #
# │                            User Configuration                            │ #
# └──────────────────────────────────────────────────────────────────────────┘ #
  # Update MANPATH
  export MANPATH="/usr/local/man:$MANPATH"
  export MANPATH=/usr/local/texlive/2020/texmf-dist/doc/man:$MANPATH
  # Update INFOPATH
  export INFOPATH=/usr/local/texlive/2020/texmf-dist/doc/info:$INFOPATH
  # Editor
  export EDITOR='nvim'
  # Vi mode
  set -o vi
  # Using neovim as a manpager
  export MANPAGER='nvim +Man!'
# ┌──────────────────────────────────────────────────────────────────────────┐ #
# │                          Keyboard Configuration                          │ #
# └──────────────────────────────────────────────────────────────────────────┘ #
  bindkey '^[[Z' reverse-menu-complete
# ┌──────────────────────────────────────────────────────────────────────────┐ #
# │                                   NVM                                    │ #
# └──────────────────────────────────────────────────────────────────────────┘ #
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
