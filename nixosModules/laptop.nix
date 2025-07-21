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

  };


  # config = lib.mkIf cfg.enable (lib.mkMerge [
  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;
    users.users.${user}.extraGroups = [ "networkmanager" ];

    environment.systemPackages = with pkgs; [
      acpi
      powerstat
      powertop
      brightnessctl

      wl-clipboard
      htop

      kitty
      mako
      waybar
      nixd
    ];
    services = {
      upower.enable = true;
      acpid.enable = true;
      pipewire.enable = true;
      thermald.enable = lib.mkIf (cfg.enableThermald && hasIntelCPU) (lib.mkDefault true);
    };
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };
}
