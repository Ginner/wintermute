{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.myHomeModules.cliPrograms.git;
  user = config.userGlobals.username;
in
{
  options.myHomeModules.cliPrograms.git = {
    enable = lib.mkEnableOption "Enable useer level git";

    user = lib.mkOption {
      type = lib.types.str;
      default = config.myModules.services.hyprland.enable or false;
      description = "Git user name";
    };

    mail = lib.mkOption {
      type = lib.types.str;
      description = "Git mail";
    };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = cfg.user;
      userMail = cfg.mail;
    };
  };
}
