{ pkgs, config, ... }:

# let
#   unstable = import
#     (builtins.fetchTarball {
#       url = "https://github.com/nixos/nixpkgs/tarball/nixos-unstable";
#       sha256 = "sha256:0y1qzff8kiypijbbckyanlrginz62n5mpp8xsbs180flj58snzjg";
#     })
#     {
#       system = pkgs.system;
#       config = config.nixpkgs.config;
#     };
# in
{
  imports = [
    ./hardware-configuration.nix
    ./tailscale.nix
    ./i3.nix
  ];

  programs.neovim = {
    enable = true;
    # package = unstable.neovim-unwrapped;
    # package = pkgs.neovim;
    defaultEditor = true;
    vimAlias = true;
  };
}
