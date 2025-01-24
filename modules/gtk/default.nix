{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.gtk;
in {
  options.modules.gtk = { enable = mkEnableOption "gtk"; };

  config = mkIf cfg.enable {
    dconf = {
      enable = true;
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
    gtk =
      {
        enable = true;

        iconTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };

        theme = {
          name = "Orchis-Dark-Compact";
          package = pkgs.orchis-theme;
        };

        cursorTheme = {
          name = "macOS-Monterey";
          package = pkgs.apple-cursor;
        };

        gtk3.extraConfig = {
          Settings = ''
            gtk-application-prefer-dark-theme=1
          '';
        };

        gtk4.extraConfig = {
          Settings = ''
            gtk-application-prefer-dark-theme=1
          '';
        };
      };
  };
}
