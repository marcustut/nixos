{ lib, pkgs, ... }:

{
  imports = [
    # Hardware config (bootloader, kernel modules, filesystems, etc)
    ./hardware-configuration.nix

    # Configuration for as a headscale server
    ./headscale.nix

    # Configuration for as a server
    ./server.nix

    # Configuration for a k3s cluster
    ./k3s.nix
  ];
}
