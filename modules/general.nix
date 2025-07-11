{ pkgs, ... }:

{
  # Nix
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Allow installing unfree packages
  nixpkgs.config = {
    allowUnfree = true;
  };

  # Configure boot
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [
      "ntfs"
      "exfat"
    ];
  };

  # Easiest to use and most distros use this by default.
  networking.networkmanager.enable = true;

  # Configure DNS servers
  networking.nameservers = [ "1.1.1.1" ];

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    git # version control system
    vim # default editor
    curl # networking
    htop # system usage
    unzip # zip
    zip # zip
    gcc # GNU C compiler
    pipewire # wayland screen stuff
    pavucontrol # audio control panel
    home-manager # home manager for configurations
  ];

  # Fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      font-awesome
      source-han-sans
      open-sans
      source-han-sans-japanese
      source-han-serif-japanese
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
    ];
    fontconfig.defaultFonts = {
      serif = [
        "Noto Serif"
        "Source Han Serif"
      ];
      sansSerif = [
        "Open Sans"
        "Source Han Sans"
      ];
      monospace = [ "JetBrainsMono Nerd Font" ];
      emoji = [ "Noto Color Emoji" ];
    };
    enableDefaultPackages = true;
  };

  # Enable sound (pipewire).
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
  };

  # Enable bluetooth.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Enable graphics
  hardware.graphics = {
    enable = true;
  };

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

  # Cache and speed up direnv
  services.lorri.enable = true;

  # Enable bluetooth GUI
  services.blueman.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kuala_Lumpur";

  i18n = {
    # Select internationalisation properties.
    defaultLocale = "en_US.UTF-8";

    # Chinese pinyin input
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        fcitx5-chinese-addons
      ];
    };
  };

  # Keyboard layout
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
  system.stateVersion = "24.11"; # Did you read the comment?
}
