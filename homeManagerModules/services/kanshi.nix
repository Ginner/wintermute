{ config, lib, pkgs, ... }:
{
  options.myHomeModules.services.kanshi = {
    enable = lib.mkEnableOption "Display output profiles";
  };

  config = lib.mkIf config.myHomeModules.services.kanshi.enable {
    services.kanshi = {
      enable = true;
      systemdTarget = "hyprland-session.target";
    };
  };
}
