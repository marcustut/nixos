{ pkgs, inputs, ... }:

{
  imports = [ ../../modules/default.nix ];
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
      kubectx # kubernetes context switch
      awscli2 # aws cli
      exfatprogs # exfat filesystem
      nixpkgs-fmt # format nix files
      bottom # better htop
      brave # browser
      inputs.zen-browser.packages.${pkgs.system}.default # zen browser
      dig # dns tool
      hurl # btter curl
      rustdesk # remote desktop
      # rustup # rust manager
      spacedrive # cross-platform drive
      bws # bitwarden cli
      nodejs # node.js
      nushell # better data processing shell
      remmina # xrdp client
      dbeaver-bin # database gui client
      patchelf # patch binary in nixos
      zellij # terminal muxer
    ];
    modules = {
      git.enable = true;
      gtk.enable = true;
      hyprland.enable = true;
      i3.enable = false;
      zsh.enable = true;
      tmux.enable = true;
    };
  };
}
