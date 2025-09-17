{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.laptop;
  hasIntelCPU = config.hardware.cpu.intel.updateMicrocode or false;
  hasAMDCPU = config.hardware.cpu.amd.updateMicrocode or false;
  user = config.userGlobals.username;
in
{
  imports = [
    ./services/tlp.nix

    # Remember to disable these for servers
    ./services/greetd.nix
    ./services/pipewire.nix

    ./programs
    ./shared/stylix.nix
  ];

  options.myModules.laptop = {
    enable = lib.mkEnableOption "Laptop-specific system configurations";

    enableThermald = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable thermald for Intel CPU thermal management";
    };

    enableTouchpad = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable touchpad support";
    };
  };


  # config = lib.mkIf cfg.enable (lib.mkMerge [
  config = lib.mkIf cfg.enable {
    # Enable laptop-specific services through module options
    myModules.services.tlp.enable = lib.mkDefault true;
    myModules.services.pipewire.enable = lib.mkDefault true;
    myModules.shared.stylix.enable = lib.mkDefault true;

    networking.networkmanager.enable = true;
    users.users.${user}.extraGroups = [ "networkmanager" ];

    environment.systemPackages = with pkgs; [
      acpi
      powerstat
      powertop
      brightnessctl
      wl-clipboard
      htop
    ] ++ lib.optionals hasIntelCPU [
      powertop
    ] ++ lib.optionals hasAMDCPU [
      ryzenadj
    ];

    services = {
      upower.enable = true;
      acpid.enable = true;
      thermald.enable = lib.mkIf (cfg.enableThermald && hasIntelCPU) (lib.mkDefault true);
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

    # Enable touchpad support for laptops
    services.libinput.enable = lib.mkIf cfg.enableTouchpad true;
  };
}
