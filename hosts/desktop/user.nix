{ pkgs, ... }:

{
  imports = [ ../../modules/default.nix ];
  config = {
    home.packages = with pkgs; [
      google-chrome # browser
      firefox # browser
      unstable.neovim # editor
      neovide # neovim gui
      vscode # editor
      gh # github cli
      pavucontrol # audio control panel
      jq # JSON processor
      yq # YAML processor
      openssl # openssl
      kubectx # kube context switch
      fzf # fuzzy finder
      k9s # kube dashboard
      feh # image viewer
      tmux # terminal sessions
      kubectl # kubernetes cli
      dbeaver-bin # database gui client
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
      davinci-resolve # video editor
    ];
    modules = {
      git.enable = true;
      zsh.enable = true;
      hyprland.enable = true;
      gtk.enable = true;
    };
  };
}
