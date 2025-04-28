{ pkgs, config, ... }:

let
  unstable = import
    (builtins.fetchTarball {
      url = "https://github.com/nixos/nixpkgs/tarball/nixos-unstable";
      sha256 = "sha256:0b1sxjghybf0fis20i9vjg79xwrjw597437v87clva97ghgbf3l7";
    })
    {
      system = pkgs.system;
      config = config.nixpkgs.config;
    };
in
{
  imports = [
    ./hardware-configuration.nix
    ./tailscale.nix
    # ./i3.nix
  ];

  programs.neovim = {
    enable = true;
    package = unstable.neovim-unwrapped;
    defaultEditor = true;
    vimAlias = true;
  };
}
