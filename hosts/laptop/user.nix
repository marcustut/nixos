{ pkgs, inputs, ... }:

{
  imports = [ ../../home-manager/default.nix ];
  config = {
    home.packages = with pkgs; [
      vscode # editor
      gh # github cli
      jq # JSON processor
      yq-go # YAML processor
      openssl # openssl
      sshs # ssh manager
      k9s # kube dashboard
      kubectl # kubernetes cli
      kubectl-cnpg # kubectl cnpg plugin
      kubectl-klock # kubectl plugin for watch
      kubernetes-helm # helm charts for kubernetes
      kubectx # kubernetes context switch
      eksctl # eks control cli
      cmctl # cert-manager cli
      awscli2 # aws cli
      exfatprogs # exfat filesystem
      nixfmt-rfc-style # format nix files
      rustup # rust toolchain
      bottom # better htop
      inputs.zen-browser.packages.${pkgs.system}.default # zen browser
      google-chrome # chrome browser
      dig # dns tool
      hurl # btter curl
      rustdesk-flutter # remote desktop
      nodejs # node.js
      nushell # better data processing shell
      remmina # xrdp client
      dbeaver-bin # database gui client
      patchelf # patch binary in nixos
      zellij # terminal muxer
      parsec-bin # remote gaming
      minio-client # minio cli
      neovide # nvim gui
      hyperfine # benchmark tool
      ghostty # terminal
    ];
    modules = {
      git.enable = true;
      gtk.enable = true;
      hyprland.enable = true;
      fish.enable = true;
      tmux.enable = true;
    };
  };
}
