{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.modules.i3;
  mod = "Mod1";
in
{
  options.modules.i3 = { enable = mkEnableOption "i3"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xclip # X11 clipboard
      xdotool # fake keyboard/mouse input
      maim # cli screenshot
    ];

    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = {
        modifier = mod;
        keybindings = lib.mkOptionDefault {
          # Shortcuts
          "${mod}+Return" = "exec ghostty";
          "${mod}+q" = "kill";

          # Focus
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";

          # Move
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";

          # Hot keys
          "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status";
          "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status";
          "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status";
          "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status";
          "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl s +5% && $refresh_i3status";
          "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl s 5%- && $refresh_i3status";
          "${mod}+Shift+s" = "exec --no-startup-id maim --select | xclip -selection clipboard -t image/png";
        };
      };
    };
  };
}
