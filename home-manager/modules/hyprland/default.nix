{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.zsh;
in
{
  options.modules.hyprland = {
    enable = mkEnableOption "hyprland";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprpaper # wallpaper
      wofi # app launcher
      waybar # status bar
      wl-clipboard # clipboard for wayland
      xclip # clipboard for X (for XWayland apps)
      clipnotify # clipboard server
      grim # grab images from wayland compositor
      slurp # select an region on screen
      swaynotificationcenter # swaync
      networkmanagerapplet # network manager gui
      lm_sensors # hardware sensors (needed by waybar)
      brightnessctl # brightness control
      pulseaudio # volume control
    ];

    wayland.windowManager.hyprland = {
      enable = true;

      # plugins = [
      #   inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      # ];

      extraConfig = ''
        # See https://wiki.hyprland.org/Configuring/Monitors/
        monitor=,preferred,auto,1.0
        #monitor=eDP-1,disabled

        # See https://wiki.hyprland.org/Configuring/Keywords/ for more

        # Execute your favorite apps at launch
        exec-once = waybar & hyprpaper & swaync & nm-applet

        # For pinyin
        # windowrule = pseudo
        # exec-once=fcitx5 -d -r
        # exec-once=fcitx5-remote -r

        # Some default env vars.
        env = XCURSOR_SIZE, 24
        env = GTK_THEME, Orchis-Dark-Compact

        # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
        input {
            kb_layout = us
            kb_variant =
            kb_model =
            kb_options =
            kb_rules =

            follow_mouse = 1

            touchpad {
                natural_scroll = no
            }

            sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
        }

        general {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more

            gaps_in = 5
            gaps_out = 20
            border_size = 2
            col.active_border = rgba(595959aa)
            col.inactive_border = rgb(282828)

            layout = dwindle

            # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
            allow_tearing = false
        }

        decoration {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more

            rounding = 10

            blur {
                enabled = true
                size = 3
                passes = 1
            }

            # drop_shadow = yes
            # shadow_range = 4
            # shadow_render_power = 3
            # col.shadow = rgba(1a1a1aee)
        }

        animations {
            enabled = false

            # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

            bezier = myBezier, 0.05, 0.9, 0.1, 1.05

            animation = windows, 1, 7, myBezier
            animation = windowsOut, 1, 7, default, popin 80%
            animation = border, 1, 10, default
            animation = borderangle, 1, 8, default
            animation = fade, 1, 7, default
            animation = workspaces, 1, 6, default
        }

        dwindle {
            # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
            pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = yes # you probably want this
        }

        master {
            # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
            # new_is_master = true
        }

        gestures {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            workspace_swipe = off
        }

        misc {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            force_default_wallpaper = 0 # Set to 0 to disable the anime mascot wallpapers
        }

        # Example per-device config
        # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
        device {
            name = epic-mouse-v1
            sensitivity = -0.5
        }

        # Example windowrule v1
        # windowrule = float, ^(ghostty)$
        # Example windowrule v2
        # windowrulev2 = float,class:^(ghostty)$,title:^(ghostty)$
        # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more


        # See https://wiki.hyprland.org/Configuring/Keywords/ for more
        $mainMod = ALT

        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        bind = $mainMod, RETURN, exec, ghostty
        bind = $mainMod, Q, killactive
        bind = $mainMod, M, exit, 
        bind = $mainMod, V, togglefloating, 
        bind = $mainMod, R, exec, wofi --show drun
        bind = $mainMod, P, pseudo, # dwindle
        bind = $mainMod, O, togglesplit, # dwindle
        bind = $mainMod, F, fullscreen # fullscreen

        # Move focus with mainMod + arrow keys
        bind = $mainMod, H, movefocus, l
        bind = $mainMod, J, movefocus, d
        bind = $mainMod, K, movefocus, u
        bind = $mainMod, L, movefocus, r

        # Switch workspaces with mainMod + [0-9]
        bind = $mainMod, 1, workspace, 1
        bind = $mainMod, 2, workspace, 2
        bind = $mainMod, 3, workspace, 3
        bind = $mainMod, 4, workspace, 4
        bind = $mainMod, 5, workspace, 5
        bind = $mainMod, 6, workspace, 6
        bind = $mainMod, 7, workspace, 7
        bind = $mainMod, 8, workspace, 8
        bind = $mainMod, 9, workspace, 9
        bind = $mainMod, 0, workspace, 10

        # Resize window
        bind = $mainMod SHIFT, H, resizeactive, -10 0
        bind = $mainMod SHIFT, J, resizeactive, 0 10
        bind = $mainMod SHIFT, K, resizeactive, 0 -10
        bind = $mainMod SHIFT, L, resizeactive, 10 0

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        bind = $mainMod SHIFT, 1, movetoworkspace, 1
        bind = $mainMod SHIFT, 2, movetoworkspace, 2
        bind = $mainMod SHIFT, 3, movetoworkspace, 3
        bind = $mainMod SHIFT, 4, movetoworkspace, 4
        bind = $mainMod SHIFT, 5, movetoworkspace, 5
        bind = $mainMod SHIFT, 6, movetoworkspace, 6
        bind = $mainMod SHIFT, 7, movetoworkspace, 7
        bind = $mainMod SHIFT, 8, movetoworkspace, 8
        bind = $mainMod SHIFT, 9, movetoworkspace, 9
        bind = $mainMod SHIFT, 0, movetoworkspace, 10

        # Example special workspace (scratchpad)
        bind = $mainMod, S, togglespecialworkspace, magic
        bind = $mainMod SHIFT, S, movetoworkspace, special:magic

        # Scroll through existing workspaces with mainMod + scroll
        bind = $mainMod, mouse_down, workspace, e+1
        bind = $mainMod, mouse_up, workspace, e-1

        # Screenshot
        # bind = , Print, exec, grim -g "$(slurp)"
        bind = SUPER_SHIFT, S, exec, grim -g "$(slurp)" -t png - | wl-copy -t image/png

        # Cycle through windows (not working)
        bind = ALT, Tab, cyclenext
        bind = ALT_SHIFT, Tab, cyclenext, prev

        # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow

        # Volume up/down
        bind = , XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%
        bind = , XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%

        # Volume mute
        bind = , XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle
        bind = , XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle

        # Brightness up/down
        bind = , XF86MonBrightnessDown, exec, brightnessctl s 5%-
        bind = , XF86MonBrightnessUp, exec, brightnessctl s +5%
      '';
    };
  };
}
