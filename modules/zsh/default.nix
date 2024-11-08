{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.zsh;
in {
  options.modules.zsh = { enable = mkEnableOption "zsh"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zsh # zsh shell
      libnotify # notify-send
      neofetch # system info
      bat # better cat
      eza # better ls
      fd # faster find
      fzf # fuzzy finder
      ripgrep # faster grep
      zsh-autocomplete # zsh autocomplete
      xdg-utils # commands such as xdg-open
    ];

    programs.zsh = {
      enable = true;

      # Set up oh-my-zsh
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };

      # Features
      syntaxHighlighting.enable = true;
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
        ls = "eza --icons";
        lla = "eza -la --icons";
        cat = "bat --paging=never --style=plain";
        grep = "rg";
        vim = "nvim";
        nixrc = "vim ~/.config/nixos";
        nd = "nix develop -c $SHELL";
        rebuild = "sudo nixos-rebuild switch --flake $HOME/.config/nixos --fast; notify-send 'Rebuild complete\!'";
      };

      # .zshrc
      initExtra = ''
        # Run neofetch on init
        neofetch

        # zsh plugins
        source ${pkgs.zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

        # Delete a word on backspace
        bindkey '^H' backward-kill-word

        # >>> conda initialize >>>
        # !! Contents within this block are managed by 'conda init' !!
        __conda_setup="$('$HOME/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
                . "$HOME/miniconda3/etc/profile.d/conda.sh"
            else
                export PATH="$HOME/miniconda3/bin:$PATH"
            fi
        fi
        unset __conda_setup
        # <<< conda initialize <<<

        # Activate default conda environment
        conda activate base

        # Allow tabby to get working directory
        precmd () { echo -n "\x1b]1337;CurrentDir=$(pwd)\x07" }
      '';
    };
  };
}
