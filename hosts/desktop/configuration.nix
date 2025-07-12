{ lib, pkgs, ... }:

{
  imports = [
    # Hardware config (bootloader, kernel modules, filesystems, etc)
    ./hardware-configuration.nix

    # Docker
    ../../modules/docker.nix

    # GNOME configuration
    ./gnome.nix

    # VPN (tailscale)
    ./tailscale.nix

    # iPhone USB Tethering
    # ./phone-tethering.nix
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marcus = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # emacs
  services.emacs = {
    enable = true;
    package = pkgs.emacs;
  };
  environment.systemPackages = with pkgs; [
    libvterm # for vterm in emacs
    libtool # for vterm in emacs
    (pkgs.callPackage ../../modules/jetbrains-fleet.nix { })
  ];

  # steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
    ];
}
