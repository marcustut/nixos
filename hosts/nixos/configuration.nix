{ config, lib, pkgs, ... }:

{
  # Allow installing unfree packages
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable NTFS
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Dublin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable bluetooth.
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable OpenGL
  hardware.opengl.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marcus = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      google-chrome   # browser
      neovim          # editor
      vscode          # editor
      kitty           # terminal
      wofi            # app launcher
      gh              # github cli
      rustup          # rust toolchains
      gcc13           # GNU C compiler v13
      fnm             # node version manager
      waybar          # status bar
      pavucontrol     # audio control panel
      neofetch        # system info
      sccache         # build caching
      jq              # JSON processor
      yq              # YAML processor
      fd              # faster find
      ripgrep         # faster grep
      gnuplot         # gnu plot
      openssl         # openssl
      kubectx         # kube context switch
      k9s             # kube dashboard
      wl-clipboard    # clipboard for wayland
      hyprpaper       # wallpaper
      feh             # image viewer
      zellij          # terminal sessions
      kubectl         # kubernetes cli
      dbeaver         # database gui client
      awscli2         # aws cli
      discord         # discord
      grim            # grab images from wayland compositor
      slurp           # select an region on screen
      obs-studio      # OBS studio
      pipewire        # wayland screen stuff
      networkmanagerapplet # network manager gui 
      exfat           # exfat filesystem
      nixpkgs-fmt     # format nix files
    ];
    shell = pkgs.zsh;
  };

  # Enable docker
  virtualisation.docker.enable = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    git 
    vim
    curl
    htop
    unzip
  ];

  # Set the default editor to vim
  environment.variables.EDITOR = "vim";

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

