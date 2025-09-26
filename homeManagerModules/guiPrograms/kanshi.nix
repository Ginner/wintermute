{ config, lib, pkgs, ... }:
{
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target"

    profiles = {
      undocked.outputs = [
        {
          criteria = "eDP-1";
          scale = 1.25;
          status = "enable";
        }
      ];

      office.outputs = [
        { criteria = "eDP-1"; position = "0,0"; scale = 1.25; }
        { criteria = "Dell Inc. DELL U2717D T4F1X87A735S"; position = "1920,480"; scale = 1.00; }
        { criteria = "Dell Inc. DELL U2417H 5K9YD734A3ES"; position = "4480,530": scale = 1.00; transform = "90"; }
      ];
    };
  };
}
