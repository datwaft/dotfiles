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
    # Go instalation
    export PATH=$PATH:/usr/local/go/bin
    # Java instalation
    export PATH=$PATH:$JAVA_HOME/bin
    # TexLive
    export PATH=$PATH:/usr/local/texlive/2020/bin/x86_64-linux
  # ┌────────────────────────────────────────────────────────────────────────────────────────────┐ #
  # │                                        Miscelaneous                                        │ #
  # └────────────────────────────────────────────────────────────────────────────────────────────┘ #
    # Java
    export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/jvm/java-11-openjdk-amd64/jre/lib/amd64/server
    # OpenSSL
    export OPENSSL_CONF=/tmp/openssl.cnf
    # Update MANPATH
    export MANPATH=/usr/local/man:$MANPATH
    export MANPATH=/usr/local/texlive/2020/texmf-dist/doc/man:$MANPATH
    # Update INFOPATH
    export INFOPATH=/usr/local/texlive/2020/texmf-dist/doc/info:$INFOPATH
