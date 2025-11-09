{ config, lib, pkgs, ... }:
{
  options.myHomeModules.guiPrograms.kanshi = {
    enable = lib.mkEnableOption "Display output profiles";
  };

  config = lib.mkIf config.myHomeModules.guiPrograms.kanshi.enable {
    services.kanshi = {
      enable = true;
      systemdTarget = "hyprland-session.target";

      settings = [
        { 
          profile.name = "undocked";
          profile.outputs = [
            { criteria = "eDP-1"; scale = 1.00; status = "enable"; }
          ];
        }
        { 
          profile.name = "office";
          profile.outputs = [
            { criteria = "eDP-1"; position = "0,0"; scale = 1.00; }
            { criteria = "Dell Inc. DELL U2717D T4F1X87A735S"; position = "1920,480"; scale = 1.00; }
            { criteria = "Dell Inc. DELL U2417H 5K9YD734A3ES"; position = "4480,530"; scale = 1.00; transform = "270"; }
          ];
        }

      ];
    };
  };
}
