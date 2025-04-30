{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
  };
  services.displayManager = {
    defaultSession = "none+i3";
  };

  environment.systemPackages = with pkgs; [
    xclip # X11 clipboard
    xdotool # fake keyboard/mouse input
    maim # cli screenshot
  ];
}
