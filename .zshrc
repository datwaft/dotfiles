# Generated automatically by `p10k`, enables the instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Do not load the configuration file if `brew` is not installed
[[ -x /opt/homebrew/bin/brew ]] || return
export HOMEBREW_BUNDLE_NO_LOCK=1
eval $(/opt/homebrew/bin/brew shellenv)
export DYLD_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_LIBRARY_PATH"
export LDFLAGS="-L$(brew --prefix)/lib"
export CPPFLAGS="-I$(brew --prefix)/include"
export LIBRARY_PATH="$LIBRARY_PATH:$(brew --prefix)/lib"

# We are using `antidote` as our plugin manager
zstyle ':antidote:bundle' use-friendly-names 'yes'
source "$(brew --prefix antidote)/share/antidote/antidote.zsh"
antidote load

# Support unlimited number of file descriptors
ulimit -n unlimited

# Disable extended glob option
# See https://stackoverflow.com/a/26295653
setopt noEXTENDED_GLOB

# Load `p10k` configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# Disable history-substring-search highlighting
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="none"
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="none"
# Highlight abbreviations
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(regexp)
ZSH_HIGHLIGHT_REGEXP=('^[[:blank:][:space:]]*('${(j:|:)${(Qk)ABBR_REGULAR_USER_ABBREVIATIONS}}')$' fg=green,bold)
ZSH_HIGHLIGHT_REGEXP+=('[[:<:]]('${(j:|:)${(Qk)ABBR_GLOBAL_USER_ABBREVIATIONS}}')$' fg=blue,bold)
# Configure FZF to use Catppuccin colors
export FZF_DEFAULT_OPTS="
  --color=bg+:-1,bg:-1,spinner:#f5e0dc,hl:#f38ba8,gutter:-1
  --color=fg:#cdd6f4,header:#f38ba8,info:-1,pointer:#cba6f7
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#cba6f7
  --reverse --no-scrollbar --pointer='➤ ' --info=hidden --border=sharp"

# Enable abbreviations cursor expansion
ABBR_SET_EXPANSION_CURSOR=1
# Define an alias for dotfiles management
alias .git='git --git-dir ~/.dotfiles --work-tree ~'
# Define an alias for `ls` if `eza` is installed
which eza &> /dev/null && alias ls="eza -I $'Icon\r'"
# Define an alias for `kitten icat`
alias icat="kitten icat"
# Use `fd` for FZF if it is installed
if which fd &> /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type file --strip-cwd-prefix --follow --hidden --exclude=.git --color=always'
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --ansi"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
# Use `zoxide` as `cd`
ZOXIDE_CMD_OVERRIDE=cd
# Suggest first from history and then from completion
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Enable completion
zmodload -i zsh/complist
# Make completion menu take less space
setopt LIST_PACKED
# Define completers to use
zstyle ':completion:*' completer _extensions _complete _approximate
# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Use `LS_COLORS` on completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" "ma=1"
# Highlight current completion item
zstyle ':completion:*' menu select

function zvm_config() {
  # Sandwich-like surround keybinds
  ZVM_VI_SURROUND_BINDKEY=s-prefix
}

function zvm_after_init() {
  # Search history with <Up> and <Down>
  bindkey '^[[A' history-substring-search-up '^[[B' history-substring-search-down
  # Move to start and end of line with <Home> and <End>
  bindkey '^[[1~' beginning-of-line '^[OH' beginning-of-line
  bindkey '^[[4~' end-of-line '^[OF' end-of-line
  # Move between words with <M-Left> and <M-Right>
  bindkey '^[[1;3D' backward-subword '^[[1;3C' forward-subword
  # Remove words using <M-Backspace> and <C-w>
  bindkey '^W' backward-kill-subword '^[^?' backward-kill-subword
  # Use <Tab> and <S-Tab> for completion
  bindkey '^I' menu-complete '^[[Z' reverse-menu-complete
  # Restore arrows in completion mode
  bindkey -M menuselect '^[[D' .backward-char '^[[C' .forward-char
  bindkey -M menuselect '^[[A' .history-substring-search-up '^[[B' .history-substring-search-down
  bindkey -M menuselect '^[[1~' .beginning-of-line '^[[4~' .end-of-line
  bindkey -M menuselect '^[[1;3D' .backward-word '^[[1;3C' .forward-word
  # Completion configuration
  bindkey -M menuselect '^[' undo '^M' .accept-line ' ' accept-search
  # Edit command line with <C-f>
  autoload -z edit-command-line
  zle -N edit-command-line
  bindkey '^F' edit-command-line
  # Enable fzf keybinds
  which fzf &> /dev/null && source <(fzf --zsh)
  # Add `fzf-git-log-widget` keybind
  source ~/.zsh/fzf-git-log-widget.zsh
  bindkey '^G' fzf-git-log-widget
  # Restore zsh-abbr keybinds
  zle -N abbr-expand-and-accept
  bindkey '^M' abbr-expand-and-accept ' ' abbr-expand-and-insert '^ ' magic-space
  bindkey -M isearch ' ' magic-space '^ ' abbr-expand-and-insert
  # Configure what characters constitute a word
  export WORDCHARS=''
}

# Use user $TERMINFO
export TERMINFO_DIRS="$TERMINFO_DIRS:$HOME/.local/share/terminfo"
# Add user binaries to $PATH
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.bin"
# Add some MacOS apps to $PATH
export PATH="$PATH:/Applications/Wezterm.app/Contents/MacOS"
export PATH="$PATH:/Applications/kitty.app/Contents/MacOS"
export PATH="$PATH:/Applications/Neovide.app/Contents/MacOS"
# Configure luarocks
which luarocks &> /dev/null && zsh-defer -c 'eval $(luarocks path --bin)'
# Configure cargo
export PATH="$HOME/.cargo/bin:$PATH"
# Configure Bob (Neovim)
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
# Configure GCP SDK
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" 2> /dev/null
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc" 2> /dev/null
# Configure 1Password plugins
[[ -f $HOME/.config/op/plugins.sh ]] && source $HOME/.config/op/plugins.sh
# Configure opam
[[ -r "$HOME/.opam/opam-init/init.zsh" ]] && source "$HOME/.opam/opam-init/init.zsh" &> /dev/null

# Use Neovim as $EDITOR
export EDITOR='nvim'
export VISUAL='nvim'
# Use Neovim as $MANPAGER
export MANPAGER='nvim +Man!'

# Use UTF-8 locale
export LANG='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'
