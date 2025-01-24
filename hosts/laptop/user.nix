{ pkgs, ... }:

{
  imports = [ ../../modules/default.nix ];
  config = {
    home.packages = with pkgs; [
      unstable.neovim # editor
      gh # github cli
      jq # JSON processor
      yq-go # YAML processor
      openssl # openssl
      kubectx # kube context switch
      k9s # kube dashboard
      kubectl # kubernetes cli
      kubectx # kubernetes context switch
      awscli2 # aws cli
      exfatprogs # exfat filesystem
      nixpkgs-fmt # format nix files
      bottom # better htop
      direnv # manages shell environment
      brave # browser
      dig # dns tool
      hurl # btter curl
      rustdesk # remote desktop
      rustup # rust manager
      nodejs # node.js
    ];
    modules = {
      git.enable = true;
      gtk.enable = true;
      hyprland.enable = true;
      zsh.enable = true;
      tmux.enable = true;
    };
  };
}
