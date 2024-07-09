{ pkgs, ... }:

{
  imports = [ ../../modules/default.nix ];
  config = {
    home.packages = with pkgs; [
      brave # browser
      firefox # browser
      unstable.neovim # editor
      neovide # neovim gui
      vscode # editor
      gh # github cli
      jq # JSON processor
      yq-go # YAML processor
      openssl # openssl
      kubectx # kube context switch
      k9s # kube dashboard
      tmux # terminal sessions
      kubectl # kubernetes cli
      dbeaver-bin # database gui client
      awscli2 # aws cli
      discord # discord
      obs-studio # OBS studio
      exfatprogs # exfat filesystem
      thunderbird # email client
      nixpkgs-fmt # format nix files
      bottom # better htop
      obsidian # notetaking app
      conda # miniconda
      davinci-resolve # video editor
      anydesk # remote desktop
      direnv # manages shell environment
      redisinsight # redis gui
    ];
    modules = {
      git.enable = true;
      zsh.enable = true;
      hyprland.enable = true;
      gtk.enable = true;
    };
  };
}
