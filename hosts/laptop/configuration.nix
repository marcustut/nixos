{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./tailscale.nix
    ./i3.nix
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    defaultEditor = true;
    vimAlias = true;
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
  };

  environment.systemPackages = [
      (pkgs.callPackage ../../modules/jetbrains-fleet.nix { })
  ];
}
