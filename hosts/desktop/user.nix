{ pkgs, inputs, ... }:

{
  imports = [ ../../modules/default.nix ];
  config = {
    home.packages = with pkgs; [
      brave # browser
      firefox # browser
      vivaldi # browser
      unstable.neovim # editor
      neovide # neovim gui
      vscode # editor
      gh # github cli
      jq # JSON processor
      yq-go # YAML processor
      openssl # openssl
      k9s # kube dashboard
      tmux # terminal sessions
      kubectl # kubernetes cli
      kubectl-cnpg # kubernetes cnpg plugin
      kubectx # kube context switch
      dbeaver-bin # database gui client
      awscli2 # aws cli
      discord # discord
      obs-studio # OBS studio
      exfatprogs # exfat filesystem
      thunderbird # email client
      nixpkgs-fmt # format nix files
      bottom # better htop
      conda # miniconda
      rustdesk # remote desktop
      rustdesk-server # remote desktop server
      hurl # better curl
      direnv # manages shell environment
      sshs # ssh management ui
      lazygit # git management ui
      dig # dns tool
      inputs.wezterm.packages.${pkgs.system}.default # terminal
    ];
    modules = {
      git.enable = true;
      zsh.enable = true;
      hyprland.enable = true;
      gtk.enable = true;
    };
  };
}
