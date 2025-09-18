{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules.cliPrograms.yazi;
in
{
  options.myHomeModules.cliPrograms.yazi = {
    enable = lib.mkEnableOption "Yazi terminal file manager";

    enableZshIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable zsh integration";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = cfg.enableZshIntegration;
    };
  };
}