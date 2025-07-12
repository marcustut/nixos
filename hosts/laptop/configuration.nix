{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix # Hardware
    ../../modules/docker.nix # Docker
    ./tailscale.nix # Tailscale
    ./gnome.nix # GNOME
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marcus = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

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
    (callPackage ../../modules/jetbrains-fleet.nix { })
  ];
}
