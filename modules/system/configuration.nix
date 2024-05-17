{ config, pkgs, inputs, ... }:

{
  # Nix
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Allow installing unfree packages
  # TODO: refactor the permittedInsecure and intel drivers
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
    };
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };

  # Configure boot
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "ntfs" "exfat" ];
  };

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    htop
    unzip
  ];

  # Fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      source-han-sans
      open-sans
      source-han-sans-japanese
      source-han-serif-japanese
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Source Han Serif" ];
      sansSerif = [ "Open Sans" "Source Han Sans" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
      emoji = [ "Noto Color Emoji" ];
    };
    enableDefaultPackages = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable bluetooth.
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marcus = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # Enable docker
  virtualisation.docker.enable = true;

  # Set the default editor to vim
  environment.variables.EDITOR = "vim";

  # Enable nix-ld 
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    openssl
    curl
    wayland
    libxkbcommon
    libGL
  ];

  # Enable hyprland
  programs.hyprland.enable = true;

  # Enable and configure zsh
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      customPkgs = [
        pkgs.nix-zsh-completions
        pkgs.zsh-vi-mode
        pkgs.zsh-autocomplete
      ];
      theme = "robbyrussell";
    };
    interactiveShellInit = ''
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    '';
  };

  # Enable git
  programs.git.enable = true;

  # Enable starship
  programs.starship = {
    enable = true;
    settings = {
      gcloud.disabled = true;
    };
  };

  # Enable bluetooth GUI
  services.blueman.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Dublin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
