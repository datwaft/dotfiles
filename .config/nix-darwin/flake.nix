{
  description = "datwaft's darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
    let
      configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = with pkgs; [
          vim
          neovim
        ];

        services.nix-daemon.enable = true;
        nix.package = pkgs.nix;

        nix.settings.experimental-features = "nix-command flakes";

        programs.zsh.enable = true;

        system.configurationRevision = self.rev or self.dirtyRev or null;

        system.stateVersion = 5;

        nixpkgs.hostPlatform = "aarch64-darwin";

        homebrew.enable = true;
        homebrew.onActivation.cleanup = "zap";
        homebrew.taps = [
          "1password/tap"
          "homebrew/bundle"
          "joshmedeski/sesh"
          "saulpw/vd"
        ];
        homebrew.casks = [
          "1password-cli"
          "kitty"
          "middleclick"
          "prismlauncher"
          "quarto"
          "raycast"
          "stats"
          "whisky"
          # Fonts
          "font-iosevka"
          "font-iosevka-nerd-font"
          "font-iosevka-term-nerd-font"
          "font-jetbrains-mono"
          "font-symbols-only-nerd-font"
        ];
        homebrew.brews = [
          "antidote"
          "asdf"
          "atuin"
          "bat"
          "bear"
          "bob"
          "curl"
          "deno"
          "difftastic"
          "direnv"
          "duckdb"
          "eza"
          "fd"
          "ffmpeg"
          "folderify"
          "fzf"
          "fzy"
          "git-delta"
          "git-lfs"
          "glow"
          "graphviz"
          "httpie"
          "imagemagick"
          "jq"
          "just"
          "lazygit"
          "llvm"
          "pam-reattach"
          "ripgrep"
          "sesh"
          "tectonic"
          "tldr"
          "tmux"
          "trash"
          "tree"
          "visidata"
          "wget"
          "yq"
          "zoxide"
          "zsh"
        ];

        system.defaults = {
          NSGlobalDomain = {
            AppleEnableSwipeNavigateWithScrolls = false;
            AppleICUForce24HourTime = true;
            AppleInterfaceStyle = "Dark";
            AppleShowAllExtensions = true;
            AppleShowScrollBars = "Always";
            NSAutomaticCapitalizationEnabled = false;
            NSAutomaticDashSubstitutionEnabled = false;
            NSAutomaticPeriodSubstitutionEnabled = false;
            NSAutomaticQuoteSubstitutionEnabled = false;
            NSAutomaticSpellingCorrectionEnabled = false;
            "com.apple.keyboard.fnState" = true;
            "com.apple.trackpad.scaling" = 1.0;
          };
          WindowManager = {
            EnableStandardClickToShowDesktop = false;
          };
          alf.globalstate = 1;
          loginwindow.GuestEnabled = false;
          dock = {
            minimize-to-application = true;
            show-recents = false;
            showhidden = true;
            tilesize = 80;
            wvous-tl-corner = 1;
            wvous-tr-corner = 1;
            wvous-bl-corner = 1;
            wvous-br-corner = 1;
            persistent-apps = [
              "/System/Applications/Launchpad.app"
              "/System/Applications/Mail.app"
              "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
              "/Applications/kitty.app"
            ];
          };
          finder = {
            FXPreferredViewStyle = "Nlsv"; # list view
            ShowPathbar = true;
          };
          menuExtraClock = {
            Show24Hour = true;
            ShowDate = 1;
          };
        };
      };
    in
      {
      # Build darwin flake using:
      darwinConfigurations."Davids-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };

      darwinPackages = self.darwinConfigurations."Davids-MacBook-Pro".pkgs;
    };
}
