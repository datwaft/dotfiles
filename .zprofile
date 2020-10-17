# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                                                                                              ║ #
# ║                                                       .o88o.  o8o  oooo                      ║ #
# ║                                                       888 `"  `"'  `888                      ║ #
# ║               oooooooo oo.ooooo.  oooo d8b  .ooooo.  o888oo  oooo   888   .ooooo.            ║ #
# ║              d'""7d8P   888' `88b `888""8P d88' `88b  888    `888   888  d88' `88b           ║ #
# ║                .d8P'    888   888  888     888   888  888     888   888  888ooo888           ║ #
# ║         .o.  .d8P'  .P  888   888  888     888   888  888     888   888  888    .o           ║ #
# ║         Y8P d8888888P   888bod8P' d888b    `Y8bod8P' o888o   o888o o888o `Y8bod8P'           ║ #
# ║                         888                                                                  ║ #
# ║                        o888o                                                                 ║ #
# ║                                      Created by datwaft                                      ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #

# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                                    Environment Variables                                     ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #
  # ┌────────────────────────────────────────────────────────────────────────────────────────────┐ #
  # │                                            PATH                                            │ #
  # └────────────────────────────────────────────────────────────────────────────────────────────┘ #
    # Initial
    export PATH=$PATH:/usr/local/bin
    export PATH=$PATH:$HOME/bin
    export PATH=$PATH:$HOME/.local/bin
    # Scripts
    export PATH=$PATH:$HOME/.scripts/
    # Go instalation
    export PATH=$PATH:/usr/local/go/bin
    # TexLive
    export PATH=/usr/local/texlive/2020/bin/x86_64-linux:$PATH
  # ┌────────────────────────────────────────────────────────────────────────────────────────────┐ #
  # │                                        Miscelaneous                                        │ #
  # └────────────────────────────────────────────────────────────────────────────────────────────┘ #
    # Vim
    export NVIM=$HOME/.config/nvim
    # Java
    export JAVA_HOME=/usr/lib/jvm/java-14-oracle
    export PATH=$PATH:$JAVA_HOME/bin
    # Prolog
    export SWI_HOME_DIR=/usr/local/lib/swipl/
    export LD_LIBRARY_PATH=/usr/local/lib/swipl/lib/x86_64-linux/
    export CLASSPATH=/usr/local/lib/swipl/lib/jpl.jar
    export LD_PRELOAD=/usr/local/lib/swipl/lib/x86_64-linux/libswipl.so  
    # OpenSSL
    export OPENSSL_CONF=/tmp/openssl.cnf
    # Update MANPATH
    export MANPATH=/usr/local/man:$MANPATH
    export MANPATH=/usr/local/texlive/2020/texmf-dist/doc/man:$MANPATH
    # Update INFOPATH
    export INFOPATH=/usr/local/texlive/2020/texmf-dist/doc/info:$INFOPATH
