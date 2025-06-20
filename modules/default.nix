{ ... }:

{
  home.stateVersion = "24.11";

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  imports = [
    ./git
    ./gtk
    ./zsh
    ./hyprland
    ./i3
    ./tmux
  ];
}
