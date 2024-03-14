if status is-interactive
  # ===================
  # Theme configuration
  # ===================
    # Set theme to Rosé Pine
    fish_config theme choose 'Rosé Pine'
    # Set theme to Rosé Pine for fzf
    set -gx FZF_DEFAULT_OPTS "
    --color=fg:#908caa,bg:#191724,hl:#ebbcba
    --color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
    --color=border:#403d52,header:#31748f,gutter:#191724
    --color=spinner:#f6c177,info:#9ccfd8,separator:#403d52
    --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"
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
    fzf_configure_bindings \
      --directory=\cT \
      --git_log=\al \
      --git_status=\as \
      --history=\cR \
      --processes=\cP \
      --variables=\cV
  # ====================
  # Binary configuration
  # ====================
    # homebrew
    eval (/opt/homebrew/bin/brew shellenv)
    # asdf
    test -x (command -v brew) && source (brew --prefix asdf)/libexec/asdf.fish
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
      abbr --add vi nvim
      abbr --add vim nvim
    end
    # Set abbreviations for Neovide
    if test -x (command -v neovide)
      abbr --add nvd neovide
      abbr --add vid neovide
      abbr --add vimd neovide
    end
    # Set abbreviations for Git
    abbr --add gs git status
    abbr --add gss git status --short
    # Set aliases and abbreviations related to `ls`
    if test -x (command -v eza)
      alias ls "eza -I 'Icon'"
      abbr --add l 'ls -l'
      abbr --add la 'ls -a'
      abbr --add ll 'ls -l'
      abbr --add lla 'ls -la'
      abbr --add lsa 'ls -a'
      abbr --add lsl 'ls -l'
      abbr --add tree 'ls -T'
    end
    # Add -F flag to trash command by default
    if test -x (command -v trash)
      abbr --add trash 'trash -F'
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
end
