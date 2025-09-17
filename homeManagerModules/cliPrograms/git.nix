{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.myHomeModules.cliPrograms.git;
in
{
  options.myHomeModules.cliPrograms.git = {
    enable = lib.mkEnableOption "User level git configuration";

    userName = lib.mkOption {
      type = lib.types.str;
      default = "User";
      description = "Git user name";
    };

    userEmail = lib.mkOption {
      type = lib.types.str;
      default = "user@example.com";
      description = "Git user email";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;
    };
  };
}
