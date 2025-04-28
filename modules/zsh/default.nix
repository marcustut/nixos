{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.zsh;
in {
  options.modules.zsh = { enable = mkEnableOption "zsh"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      libnotify # notify-send
      neofetch # system info
      zoxide # better cd
      bat # better cat
      eza # better ls
      fd # faster find
      fzf # fuzzy finder
      ripgrep # faster grep
      xdg-utils # commands such as xdg-open

      # zsh plugins
      zsh-syntax-highlighting # fish like syntax highlighting
      zsh-autosuggestions # zsh autosuggestions
      zsh-fzf-tab # replace completion menu with fzf
    ];

    # Enable starship
    programs.starship = {
      enable = false;
    };

    # Enable direnv support for ZSH
    programs.direnv.enableZshIntegration = true;

    programs.zsh = {
      enable = true;

      # Set up oh-my-zsh
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "colorize" ];
        theme = "cypher";
      };

      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
      ];

      # Features
      syntaxHighlighting.enable = false;
      enableCompletion = false;

      # Tweak settings for history
      history = {
        save = 1000;
        size = 1000;
        path = "$HOME/.cache/zsh_history";
      };

      # Aliases
      shellAliases = {
        g = "git";
        k = "kubectl";
        kns = "kubens";
        kctx = "kubectx";
        cd = "z";
        ls = "eza --icons";
        lla = "eza -la --icons";
        cat = "bat --paging=never --style=plain";
        grep = "rg";
        vim = "nvim";
        nixrc = "vim ~/.config/nixos";
        nd = "nix develop -c $SHELL";
        rebuild = "sudo nixos-rebuild switch --flake $HOME/.config/nixos --fast";
      };

      # .zshrc
      initExtra = ''
        # Run neofetch on init
        neofetch

        # zsh plugins
        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.zsh

        # Completion styling
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "$${(s.:.)LS_COLORS}"
        zstyle ':completion:*' menu no

        # Delete a word on backspace
        bindkey '^H' backward-kill-word

        # Allow tabby to get working directory
        precmd () { echo -n "\x1b]1337;CurrentDir=$(pwd)\x07" }

        # Add to path
        export PATH="/bin:$PATH"
        export PATH="/snap/bin:$PATH" 

        # Shell integrations
        eval "$(fzf --zsh)"
        eval "$(zoxide init zsh)"
      '';
    };
  };
}
