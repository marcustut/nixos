{ pkgs, ... }:

{
  imports = [ ../../modules/default.nix ];
  config = {
    home.packages = with pkgs; [
      firefox # browser
      unstable.neovim # editor
      gh # github cli
      jq # JSON processor
      yq-go # YAML processor
      openssl # openssl
      k9s # kube dashboard
      kubectl # kubernetes cli
      kubectl-cnpg # kubernetes cnpg plugin
      kubectx # kube context switch
      awscli2 # aws cli
      exfatprogs # exfat filesystem
      nixpkgs-fmt # format nix files
      bottom # better htop
      rustup # rust toolchain
      rustdesk # remote desktop
      rustdesk-server # remote desktop server
      dig # dns tool
    ];
    modules = {
      git.enable = true;
      gtk.enable = false;
      zsh.enable = true;
      hyprland.enable = false;
      i3.enable = true;
      tmux.enable = true;
    };
  };
}
