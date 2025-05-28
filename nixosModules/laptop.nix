{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.laptop;
  hasIntelCPU = config.hardware.cpu.intel.updateMicrocode or false;
  hasAMDCPU = config.hardware.cpu.amd.updateMicrocode or false;
in
{
  options.myModules.laptop = {
    enable = lib.mkEnableOption "Laptop-specific system configurations";

    powerManagement = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable power management features";
      };
    };

  };


  config = lib.mkIf cfg.enable (lib.mkMerge [

      (lib.mkIf cfg.powerManagement.enable {
        myModules.services.tlp.enable = true;
      })
      (lib.mkIf (cfg.thermald.enable && hasIntelCPU) {
        services.thermald.enable = true;
      })
    {
      environment.systemPackages = with pkgs; [
        acpi
        acpid
        lm_sensors
        upower
      ];
      services.upower.enable = true;
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
      hardware.bluetooth.enable = true;
    }
  ]);
}
