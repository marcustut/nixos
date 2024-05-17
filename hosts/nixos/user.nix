{ config, pkgs, home, inputs, ... }:

{
  imports = [ ../../modules/default.nix ];
  config = {
    home.packages = with pkgs; [
      google-chrome # browser
      neovim # editor
      vscode # editor
      kitty # terminal
      wofi # app launcher
      gh # github cli
      rustup # rust toolchains
      gcc13 # GNU C compiler v13
      fnm # node version manager
      waybar # status bar
      pavucontrol # audio control panel
      neofetch # system info
      sccache # build caching
      jq # JSON processor
      yq # YAML processor
      fd # faster find
      ripgrep # faster grep
      gnuplot # gnu plot
      openssl # openssl
      kubectx # kube context switch
      k9s # kube dashboard
      wl-clipboard # clipboard for wayland
      hyprpaper # wallpaper
      feh # image viewer
      zellij # terminal sessions
      kubectl # kubernetes cli
      dbeaver # database gui client
      awscli2 # aws cli
      discord # discord
      grim # grab images from wayland compositor
      slurp # select an region on screen
      obs-studio # OBS studio
      pipewire # wayland screen stuff
      networkmanagerapplet # network manager gui 
      exfatprogs # exfat filesystem
      thunderbird # email client
      swaynotificationcenter # swaync
      nixpkgs-fmt # format nix files
      beeper # chat apps
      lm_sensors # hardware sensors
      xdg-utils # commands such as xdg-open
      bottom # better htop
      brightnessctl # brightness control
      apple-cursor # apple's cursor theme 
      obsidian # notetaking app
    ];
    modules = {
      # cli
      git.enable = true;
    };
  };
}
