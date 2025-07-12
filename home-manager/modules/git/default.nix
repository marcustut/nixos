{ lib, config, ... }:

with lib;
let
  cfg = config.modules.git;
in
{
  options.modules.git = {
    enable = mkEnableOption "git";
    userName = mkOption {
      type = types.str;
      default = "marcustut";
      description = "Git user name";
    };
    userEmail = mkOption {
      type = types.str;
      default = "marcustutorial@hotmail.com";
      description = "Git user email";
    };
    defaultBranch = mkOption {
      type = types.str;
      default = "main";
      description = "Default branch name for new repositories";
    };
  };
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;
      extraConfig = {
        init = {
          defaultBranch = cfg.defaultBranch;
        };
        # core = {
        #   excludesfile = "$NIXOS_CONFIG_DIR/scripts/gitignore";
        # };
      };
    };
  };
}
