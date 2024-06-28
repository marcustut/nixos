{ lib, pkgs, ... }:

{
  imports = [
    # Hardware config (bootloader, kernel modules, filesystems, etc)
    ./hardware-configuration.nix

    # GNOME configuration
    ./gnome.nix

    # Configuration for as a server
    ./server.nix
  ];

  # steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
  ];

  # mobile device integration
  services.usbmuxd.enable = true;
  environment.systemPackages = with pkgs; [
    libimobiledevice # mobile tethering
    ifuse # ios mount
  ];
}
