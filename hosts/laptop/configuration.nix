{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./tailscale.nix
    # ./i3.nix
    ./gnome.nix
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    defaultEditor = true;
    vimAlias = true;
  };
}
