{ pkgs, lib, ... }:

{
  # Gnome
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Enable dconf
  programs.dconf = {
    enable = true;
    profiles.gdm.databases = [{
      settings."org/gnome/settings-daemon/plugins/power" = {
        # - Time inactive in seconds before suspending with AC power
        #   1200=20 minutes, 0=never
        sleep-inactive-ac-timeout = lib.gvariant.mkInt32 0;
        # - What to do after sleep-inactive-ac-timeout
        #   'blank', 'suspend', 'shutdown', 'hibernate', 'interactive' or 'nothing'
        # sleep-inactive-ac-type='suspend'
        sleep-inactive-ac-type = "nothing";
        # - As above but when on battery
        # sleep-inactive-battery-timeout=1200
        # sleep-inactive-battery-type='suspend'
      };
    }];
  };

  # Install GNOME Tweaks
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnomeExtensions.gsconnect # GSConnect (sync clipboard with mobile devices)
    xclip # X11 clipboard
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
