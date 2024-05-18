{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.zsh;
in {
  options.modules.zsh = { enable = mkEnableOption "zsh"; };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.zsh
    ];

    programs.zsh = {
      enable = true;

      # Set up oh-my-zsh
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };

      syntaxHighlighting.enable = true;

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
        ls = "eza --icons";
        lla = "eza -la --icons";
        cat = "bat --paging=never --style=plain";
        vim = "nvim";
        nixrc = "vim ~/.config/nixos";
        nd = "nix develop -c $SHELL";
        rebuild = "sudo nixos-rebuild switch --flake $HOME/.config/nixos --fast; notify-send 'Rebuild complete\!'";
      };

      # .zshrc
      initExtra = ''
        # Run neofetch on init
        neofetch

        # FNM setup
        eval "$(fnm env --use-on-cd)"

        # Delete a word on backspace
        bindkey '^H' backward-kill-word
      '';
    };
  };
}
