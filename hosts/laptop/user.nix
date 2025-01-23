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
      tmux # terminal sessions
      kubectl # kubernetes cli
      kubectx # kubernetes context switch
      awscli2 # aws cli
      exfatprogs # exfat filesystem
      nixpkgs-fmt # format nix files
      bottom # better htop
      direnv # manages shell environment
      brave # browser
      dig # dns tool
      rustdesk # remote desktop
      hurl # btter curl
    ];
    modules = {
      git.enable = true;
      zsh.enable = true;
      hyprland.enable = true;
      gtk.enable = true;
    };
  };
}
