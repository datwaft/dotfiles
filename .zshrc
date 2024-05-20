# Start with beam cursor
# See https://stackoverflow.com/a/17100535/10702981
printf '\e[6 q'

# Generated automatically by `p10k`, enables the instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Do not load the configuration file if `brew` is not installed
which brew &> /dev/null || return
eval $(/opt/homebrew/bin/brew shellenv)

# We are using `antidote` as our plugin manager
zstyle ':antidote:bundle' use-friendly-names 'yes'
source "$(brew --prefix antidote)/share/antidote/antidote.zsh"
antidote load

# Support unlimited number of file descriptors
ulimit -n unlimited

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
alias .git='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
# Define an alias for `ls` if `eza` is installed
which eza &> /dev/null && alias ls="eza -I $'Icon\r'"
# Use `fd` for FZF if it is installed
if which fd &> /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type file --strip-cwd-prefix --follow --hidden --exclude=.git --color=always'
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --ansi"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
# Use `zoxide` as `cd`
ZOXIDE_CMD_OVERRIDE=cd

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Use `LS_COLORS` on completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

function zvm_config() {
  # Sandwich-like surround keybinds
  ZVM_VI_SURROUND_BINDKEY=s-prefix
}

function zvm_after_init() {
  # Search history with <Up> and <Down>
  bindkey '^[[A' history-substring-search-up # <Up>
  bindkey '^[[B' history-substring-search-down # <Down>
  # Move to start and end of line with <Home> and <End>
  bindkey '^[[1~' beginning-of-line # <Home>
  bindkey '^[[4~' end-of-line # <End>
  # Move between words with <M-Left> and <M-Right>
  bindkey '^[[1;3D' backward-word # <M-Left>
  bindkey '^[[1;3C' forward-word # <M-Right>
  # Use <Tab> and <S-Tab> for completion
  bindkey '^I' menu-select '^[[Z' menu-select
  bindkey -M menuselect '^I' menu-complete '^[[Z' reverse-menu-complete
  # Abort completion with <ESC>
  bindkey -M menuselect '^[' undo # <ESC>
  # Always submit with <Enter>
  bindkey -M menuselect '^M' .accept-line
  # Accept completion with <Space>
  bindkey -M menuselect ' ' accept-search
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
  bindkey '^M' abbr-expand-and-accept ' ' abbr-expand-and-insert '^ ' magic-space
  bindkey -M isearch ' ' magic-space '^ ' abbr-expand-and-insert
}

# Use user $TERMINFO
export TERMINFO_DIRS="$TERMINFO_DIRS:$HOME/.local/share/terminfo"
# Add user binaries to $PATH
export PATH="$PATH:$HOME/.local/bin"
# Add some MacOS apps to $PATH
export PATH="$PATH:/Applications/Wezterm.app/Contents/MacOS"
export PATH="$PATH:/Applications/kitty.app/Contents/MacOS"
export PATH="$PATH:/Applications/Neovide.app/Contents/MacOS"
# Configure luarocks
which luarocks &> /dev/null && eval $(luarocks path --bin)
# Configure cargo
export PATH="$PATH:$HOME/.cargo/bin"
# Configure Bob (Neovim)
export PATH="$PATH:$HOME/.local/share/bob/nvim-bin"

# Use Neovim as $EDITOR
export EDITOR='nvim'
export VISUAL='nvim'
# Use Neovim as $MANPAGER
export MANPAGER='nvim +Man!'

# Use UTF-8 locale
export LANG='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'
