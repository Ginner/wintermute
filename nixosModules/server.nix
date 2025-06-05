{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.laptop;
in
{
  options.myModules.server = {
    enable = lib.mkEnableOption "Server-specific system configurations";
    enableGreetd = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable greetd for login management";
    };
    enableHyprland = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Hyprland as the window manager";
    };

    powerManagement = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable power management features";
      };
    };

  };


  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      myModules.services.xremap.enable = true;
      myModules.services.pipewire.enable = true;
      hardware.bluetooth.enable = true;

      (lib.mkIf cfg.powerManagement.enable {
        myModules.services.tlp.enable = true;
      })
      (lib.mkIf (cfg.thermald.enable && hasIntelCPU) {
        services.thermald.enable = true;
      })
    {
      environment.systemPackages = with pkgs; [
        lm_sensors
        git
      ];
    }
    {
      myModules.services.xremap = {
        enable = true; # Enable xremap with default CapsLock remap
        withHypr = true; # Only if using Hyprland
      };
    }
    {
      myModules.services.pipewire.enable = true;
    }
    {
      services.openssh.enable = true;
    }
  ]);
}
