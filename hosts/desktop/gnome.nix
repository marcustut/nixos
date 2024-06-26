{ pkgs, ... }:

{
  # Gnome
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Enable dconf
  programs.dconf.enable = true;

  # Install GNOME Tweaks
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnomeExtensions.gsconnect # GSConnect (sync clipboard with mobile devices)
  ];

  # Exclude some default GNOME packages
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    pkgs.gedit # text editor
    geary # email reader
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    yelp # Help view
    gnome-contacts
    gnome-initial-setup
  ]);
}
