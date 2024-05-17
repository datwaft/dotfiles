if status is-interactive
  # ===================
  # Theme configuration
  # ===================
    # Set theme to Catppuccin Mocha
    fish_config theme choose 'Catppuccin Mocha'
    # Set theme to Catppuccin Mocha for FZF
    set -gx FZF_DEFAULT_OPTS "\
    --color=bg+:-1,bg:-1,spinner:#f5e0dc,hl:#f38ba8,gutter:-1 \
    --color=fg:#cdd6f4,header:#f38ba8,info:-1,pointer:#cba6f7 \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#cba6f7 \
    --reverse --no-scrollbar --pointer='➤ ' --info=hidden --border=sharp"
    # Set theme to base16 for bat
    set -gx BAT_THEME base16
  # ====================
  # Prompt configuration
  # ====================
    # Remove some items from the right prompt
    for item in aws kubectl
      set -g tide_right_prompt_items (string match -v $item $tide_right_prompt_items)
    end
  # =====================
  # Keybind configuration
  # =====================
    # Enable vi key bindings
    set -g fish_vi_force_cursor 1
    fish_vi_key_bindings
    # Change cursor shape based on current mode
    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore
    set fish_cursor_replace underscore
    set fish_cursor_external line
    set fish_cursor_visual block
    # Edit current command in EDITOR with <C-f>
    # The echo is a workaround for the cursor not changing properly
    bind --mode insert \cf 'edit_command_buffer; echo -e "\033[6 q"'
    # Use <space> to accept completion
    bind --mode insert \x20 '
      if commandline -P
        commandline -f execute
      else
        commandline -f expand-abbr
        commandline -i " "
      end
    '
    # Configure fzf.fish plugin keybinds
    _fzf_uninstall_bindings
    bind --mode insert \cR _fzf_search_history
    bind --mode insert \cT _fzf_search_directory
    bind --mode insert \al _fzf_search_git_log
  # ====================
  # Binary configuration
  # ====================
    # homebrew
    type -q /opt/homebrew/bin/brew && eval (/opt/homebrew/bin/brew shellenv)
    # asdf
    type -q asdf && source (brew --prefix asdf)/libexec/asdf.fish
    # direnv
    type -q direnv && direnv hook fish | source
  # ==================
  # PATH configuration
  # ==================
    # Define a function for adding folders to PATH if they exist
    function add_folder_to_path
      if test -d $argv[1]
        fish_add_path --path --move $argv[1]
      end
    end
    # Homebrew
    add_folder_to_path /opt/homebrew/bin
    add_folder_to_path /opt/homebrew/sbin
    # asdf
    add_folder_to_path ~/.asdf/shims
    # User scripts
    add_folder_to_path ~/.dotfiles/bin
    # User binaries
    add_folder_to_path ~/bin
    add_folder_to_path ~/.local/bin
    # Cargo
    add_folder_to_path ~/.cargo/bin
    # Deno
    add_folder_to_path ~/.deno/bin
    # Poetry
    add_folder_to_path ~/.poetry/bin
    # Wezterm
    add_folder_to_path /Applications/Wezterm.app/Contents/MacOS
    # Kitty
    add_folder_to_path /Applications/kitty.app/Contents/MacOS
    # Neovide
    add_folder_to_path /Applications/Neovide.app/Contents/MacOS
    # LLVM
    type -q brew && add_folder_to_path (brew --prefix)/opt/llvm/bin
    # Bob (Neovim)
    add_folder_to_path ~/.local/share/bob/nvim-bin
    # Bun
    add_folder_to_path ~/.bun/bin
  # =========================
  # Abbreviations and Aliases
  # =========================
    # Set alias for dotfiles Git
    alias .git 'git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME/.dotfiles'
    # Set abbreviations for dotfiles Git
    abbr .gs .git status
    abbr .gss .git status --short
    abbr .gc .git commit
    abbr .gcm --set-cursor={} .git commit -m \'{}\'
    abbr .gd .git diff
    abbr .gdc .git diff --cached
    abbr .gdt .git difft
    abbr .gdtc .git difft --cached
    # Set abbreviations for Git
    abbr gs git status
    abbr gss git status --short
    abbr gc git commit
    abbr gcm --set-cursor={} git commit -m \'{}\'
    abbr gd git diff
    abbr gdc git diff --cached
    abbr gdt git difft
    abbr gdtc git difft --cached
    # Set abbreviations for Neovim
    if type -q nvim
      abbr vi nvim
      abbr vim nvim
    end
    # Set abbreviations for Neovide
    if type -q neovide
      abbr nvd neovide
      abbr vid neovide
      abbr vimd neovide
    end
    # Set aliases and abbreviations related to `ls`
    if type -q eza
      alias ls "eza -I 'Icon'"
      abbr l 'ls -l'
      abbr la 'ls -a'
      abbr ll 'ls -l'
      abbr lla 'ls -la'
      abbr lsa 'ls -a'
      abbr lsl 'ls -l'
      abbr tree 'ls -T'
      abbr lgi 'ls --git-ignore'
      abbr lsgi 'ls --git-ignore'
    end
    # Add -F flag to trash command by default
    if type -q trash
      abbr trash 'trash -F'
    end
  # Set abbreviations for pnpm
    if type -q pnpm
      abbr pn 'pnpm'
    end
  # ====================
  # System configuration
  # ====================
    # Remove soft limit for the number of simultaneously opened files when using MacOS
    if test (uname) = Darwin
      ulimit -n unlimited
    end
    # Use Neovim as EDITOR
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    # Use Neovim as MANPAGER
    set -gx MANPAGER 'nvim +Man!'
    # Use local TERMINFO
    set -gax --path TERMINFO_DIRS ~/.local/share/terminfo
    # Set locale always to UTF-8
    set -gx LANG "en_US.UTF-8"
    set -gx LC_CTYPE "en_US.UTF-8"
end
