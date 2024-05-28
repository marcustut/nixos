{ config, pkgs, home, inputs, ... }:

{
  imports = [ ../../modules/default.nix ];
  config = {
    home.packages = with pkgs; [
      google-chrome # browser
      firefox # browser
      neovim # editor
      vscode # editor
      gh # github cli
      rustup # rust toolchains
      gcc13 # GNU C compiler v13
      pavucontrol # audio control panel
      sccache # build caching
      jq # JSON processor
      yq # YAML processor
      gnuplot # gnu plot
      openssl # openssl
      kubectx # kube context switch
      fzf # fuzzy finder
      k9s # kube dashboard
      feh # image viewer
      tmux # terminal sessions
      kubectl # kubernetes cli
      dbeaver # database gui client
      awscli2 # aws cli
      discord # discord
      obs-studio # OBS studio
      pipewire # wayland screen stuff
      exfatprogs # exfat filesystem
      thunderbird # email client
      nixpkgs-fmt # format nix files
      beeper # chat apps
      xdg-utils # commands such as xdg-open
      bottom # better htop
      obsidian # notetaking app
      conda # miniconda
    ];
    modules = {
      git.enable = true;
      zsh.enable = true;
      hyprland.enable = true;
      gtk.enable = true;
    };
  };
}
