{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.tmux;
in {
  options.modules.tmux = { enable = mkEnableOption "tmux"; };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      terminal = "tmux-256color";
      historyLimit = 50000;

      extraConfig = ''
        ...
        set -g status-right '#[fg=black,bg=color15] #{cpu_percentage}  %H:%M '
        run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux

        set-option -g mouse on
        set-option -g focus-events on
      '';
    };
  };
}
