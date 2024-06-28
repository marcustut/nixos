{ pkgs, ... }:

{
  imports = [ ../../modules/default.nix ];
  config = {
    home.packages = with pkgs; [
      unstable.neovim # editor
      gh # github cli
      jq # JSON processor
      yq # YAML processor
      openssl # openssl
      kubectx # kube context switch
      k9s # kube dashboard
      tmux # terminal sessions
      kubectl # kubernetes cli
      awscli2 # aws cli
      exfatprogs # exfat filesystem
      nixpkgs-fmt # format nix files
      bottom # better htop
    ];
    modules = {
      git.enable = true;
      zsh.enable = true;
      hyprland.enable = false;
      gtk.enable = false;
    };
  };
}
