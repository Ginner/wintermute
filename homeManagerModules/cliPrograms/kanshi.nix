{ config, lib, pkgs, ... }:
{
  options.myHomeModules.cliPrograms.kanshi = {
    enable = lib.mkEnableOption "Display output profiles";
  };

  config = lib.mkIf config.myHomeModules.cliPrograms.kanshi.enable {
    services.kanshi = {
      enable = true;
      systemdTarget = "hyprland-session.target";
    };
  };
}
