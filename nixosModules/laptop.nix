{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.laptop;
  hasIntelCPU = config.hardware.cpu.intel.updateMicrocode or false;
  hasAMDCPU = config.hardware.cpu.amd.updateMicrocode or false;
  user = config.userGlobals.username;
in
{
  options.myModules.laptop = {
    enable = lib.mkEnableOption "Laptop-specific system configurations";

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

    enableRemap = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable xremap for key remapping";
    };

    enablePowerManagement = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable power management features";
      };
    };

    enableBluetooth = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Bluetooth support";
    };

    enablePipewire = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable PipeWire for audio and video management";
    };

    enableNetworkManager = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable NetworkManager for network management";
    };

    enableThermald = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable thermald for thermal management";
    };

    # Make services toggleable
    # enableUpower = lib.mkEnableOption "Enable upower for power management." // { default = true; };

    # Make available packages toggleable
    addKitty = lib.mkEnableOption "Add Kitty terminal emulator." // { default = true; };
    addMako = lib.mkEnableOption "Add Mako notification daemon." // { default = true; };
    addWaybar = lib.mkEnableOption "Add Waybar as the status bar." // { default = true; }; # Swap w. AGS
    addClipboard = lib.mkEnableOption "Add wl-clipboard." // { default = true; };
    addNixdb = lib.mkEnableOption "Add the nixd nix language server." // { default = true; };

  };


  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf cfg.enableGreetd { myModules.services.greetd.enable = true; })
    (lib.mkIf cfg.enableHyprland { myModules.programs.hyprland.enable = true; })
    (lib.mkIf cfg.enableRemap {
      myModules.services.xremap.enable = true; # Enable xremap with default CapsLock remap
      myModules.services.xremap.withHypr = cfg.enableHyprland; # Only if using Hyprland
    })
    (lib.mkIf cfg.enablePowerManagement.enable {
      myModules.services.tlp.enable = true; # Enable TLP for power management
    })
    (lib.mkIf cfg.enableBluetooth { hardware.bluetooth.enable = true; })
    (lib.mkIf cfg.enablePipewire { myModules.services.pipewire.enable = true; })
    (lib.mkIf cfg.enableNetworkManager {
      networking.networkmanager.enable = true;
      users.users.${user}.extraGroups = [ "networkmanager" ];
    })


    {
      environment.systemPackages = with pkgs; [
      ];
    }
    (lib.mkIf (cfg.enableThermald && hasIntelCPU) { services.thermald.enable = true; })

    # Packages
    (lib.mkIf cfg.addKitty { environment.systemPackages = [ pkgs.kitty ]; })
    (lib.mkIf cfg.addMako { environment.systemPackages = [ pkgs.mako ]; })
    (lib.mkIf cfg.addWaybar { environment.systemPackages = [ pkgs.waybar ]; })
    (lib.mkIf cfg.addClipboard { environment.systemPackages = [ pkgs.wl-clipboard ]; })
    (lib.mkIf cfg.addNixdb { environment.systemPackages = [ pkgs.nixd ]; })
  ]);
}
