{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.i3;
in
{
  options.modules.i3 = { enable = mkEnableOption "i3"; };

  config = mkIf cfg.enable {
    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
  };
}
