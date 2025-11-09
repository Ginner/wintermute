{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.myHomeModules.cliPrograms.git;
in
{
  options.myHomeModules.cliPrograms.git = {
    enable = lib.mkEnableOption "User level git defaults";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };
}
