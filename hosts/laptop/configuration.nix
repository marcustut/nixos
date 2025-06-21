{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./tailscale.nix
    ./gnome.nix
    ./i3.nix
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    defaultEditor = true;
    vimAlias = true;
  };

  services.emacs = {
    enable = true;
    package = pkgs.emacs;
  };

  environment.systemPackages = with pkgs; [
    libvterm # for vterm in emacs
    libtool # for vterm in emacs
    cmake # to compile c projects
    (callPackage ../../modules/jetbrains-fleet.nix { })
  ];
}
