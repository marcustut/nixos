{ pkgs, ... }:

{
  imports = [ ../../home-manager/default.nix ];
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
      k9s # kube dashboard
      kubectl # kubernetes cli
      kubectl-cnpg # kubernetes cnpg plugin
      kubectx # kube context switch
      dbeaver-bin # database gui client
      awscli2 # aws cli
      discord # discord
      obs-studio # OBS studio
      exfatprogs # exfat filesystem
      thunderbird # email client
      nixfmt-rfc-style # format nix files
      bottom # better htop
      rustdesk-flutter # remote desktop
      rustdesk-server # remote desktop server
      hurl # better curl
      sshs # ssh management ui
      lazygit # git management ui
      dig # dns tool
      file # determine file type
      parsec-bin # remote gaming
    ];
    modules = {
      git.enable = true;
      gtk.enable = true;
      zsh.enable = true;
      hyprland.enable = true;
      i3.enable = false;
      tmux.enable = true;
    };
  };
}
