{ ... }:

{
  home.stateVersion = "24.11";

  imports = [
    ./packages/cli.nix
    ./packages/direnv.nix
    ./modules/git
    ./modules/gtk
    ./modules/zsh
    ./modules/fish
    ./modules/hyprland
    ./modules/i3
    ./modules/tmux
  ];
}
