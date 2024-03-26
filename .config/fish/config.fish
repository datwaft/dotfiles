if status is-interactive
  # ===================
  # Theme configuration
  # ===================
    # Set theme to Catppuccin Mocha
    fish_config theme choose 'Catppuccin Mocha'
    # Set theme to Catppuccin Mocha for fzf
    set -gx FZF_DEFAULT_OPTS "\
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
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
    fish_vi_key_bindings
    # Change cursor shape based on current mode
    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore
    set fish_cursor_replace underscore
    set fish_cursor_external line
    set fish_cursor_visual block
    # Edit current command in EDITOR with <C-f>
    bind --mode insert \cf edit_command_buffer
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
    eval (/opt/homebrew/bin/brew shellenv)
    # asdf
    test -x (command -v brew) && source (brew --prefix asdf)/libexec/asdf.fish
    # luarocks
    eval (luarocks path --bin)
  # ==================
  # PATH configuration
  # ==================
    # Define a function for adding folders to PATH if they exist
    function add_folder_to_path
      if test -d $argv[1]
        fish_add_path $argv[1]
      end
    end
    # User scripts
    add_folder_to_path ~/scripts
    # User binaries
    add_folder_to_path ~/bin
    add_folder_to_path ~/.local/bin
    # Homebrew
    add_folder_to_path /opt/homebrew/bin
    add_folder_to_path /opt/homebrew/sbin
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
    test -x (command -v brew) && add_folder_to_path (brew --prefix)/opt/llvm/bin
    # Bob (Neovim)
    add_folder_to_path ~/.local/share/bob/nvim-bin
    # Bun
    add_folder_to_path ~/.bun/bin
  # =========================
  # Abbreviations and Aliases
  # =========================
    # Set abbreviations for Neovim
    if test -x (command -v nvim)
      abbr vi nvim
      abbr vim nvim
    end
    # Set abbreviations for Neovide
    if test -x (command -v neovide)
      abbr nvd neovide
      abbr vid neovide
      abbr vimd neovide
    end
    # Set abbreviations for Git
    abbr gs git status
    abbr gss git status --short
    abbr gc git commit
    abbr gcm --set-cursor={} git commit -m \'{}\'
    abbr gd git diff
    abbr gdc git diff --cached
    abbr gdt git difft
    abbr gdtc git difft --cached
    # Set aliases and abbreviations related to `ls`
    if test -x (command -v eza)
      alias ls "eza -I 'Icon'"
      abbr l 'ls -l'
      abbr la 'ls -a'
      abbr ll 'ls -l'
      abbr lla 'ls -la'
      abbr lsa 'ls -a'
      abbr lsl 'ls -l'
      abbr tree 'ls -T'
    end
    # Add -F flag to trash command by default
    if test -x (command -v trash)
      abbr trash 'trash -F'
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
end
