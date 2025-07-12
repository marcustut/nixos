{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.fish;
in
{
  options.modules.fish = {
    enable = mkEnableOption "fish";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ fish ];

    programs.fish = {
      enable = true;
      shellAliases = {
        k = "kubectl";
        kns = "kubens";
        kctx = "kubectx";
        vim = "nvim";
        g = "git";

        grep = "rg";
        mkdir = "mkdir -p";
        cp = "cp -v --progress";
        mv = "mv -v";
        rm = "rm -v";
        ls = "eza --icons";
        lla = "eza -lah --icons";
        cat = "bat --paging=never --style=plain";
      };
      shellAbbrs = {
        # cargo abbreviations
        cb = "cargo build";
        cc = "cargo check";
        cdo = "cargo doc --open";
        cr = "cargo run";

        # git abbreviations
        gaa = "git add -A";
        ga = "git add";
        gbd = "git branch --delete";
        gb = "git branch";
        gc = "git commit";
        gcm = "git commit -m";
        gcob = "git checkout -b";
        gco = "git checkout";
        gd = "git diff";
        gl = "git log";
        gp = "git push";
        gpom = "git push origin main";
        gs = "git status";
        gst = "git stash";
        gstp = "git stash pop";

        # nix abbreviations
        ncg = "nix-collect-garbage";
        nixrc = "vim $HOME/.config/nixos";
        nd = "nix develop -c $SHELL";
        rebuild = "sudo nixos-rebuild switch --flake $HOME/.config/nixos --fast";
      };
    };
  };
}
