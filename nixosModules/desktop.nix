{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.desktop;
  hasIntelGPU = config.hardware.graphics.extraPackages != [];
  hasAMDGPU = config.hardware.graphics.extraPackages32 != [];
in
{
  imports = [
    ./services/pipewire.nix
    ./services/greetd.nix
    ./programs
    ./shared/stylix.nix
  ];

  options.myModules.desktop = {
    enable = lib.mkEnableOption "Desktop-specific system configurations";

    enableGaming = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable gaming-related packages and services";
    };

    enableMultiMonitor = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable multi-monitor support tools";
    };

    enableGraphicsTools = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable graphics and design tools";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable desktop-specific services through module options
    myModules.services.pipewire.enable = lib.mkDefault true;
    myModules.services.greetd.enable = lib.mkDefault true;
    myModules.services.brightnessctl.enable = lib.mkDefault true;
    myModules.services.fwupd.enable = lib.mkDefault true;
    myModules.services.tailscale.enable = lib.mkDefault false;  # Optional
    myModules.services.kde-connect.enable = lib.mkDefault false;  # Optional
    myModules.shared.stylix.enable = lib.mkDefault true;
    myModules.programs.hyprland.enable = lib.mkDefault true;
    myModules.programs.usbutils.enable = lib.mkDefault true;

    environment.systemPackages = config.environment.systemPackages ++ (with pkgs; [
      # Desktop utilities
      pavucontrol

      # Multi-monitor tools
    ]) ++ lib.optionals cfg.enableMultiMonitor [
      arandr
      autorandr
      wdisplays
    ] ++ lib.optionals cfg.enableGraphicsTools (with pkgs; [
      # Graphics and design tools
      gimp
      blender
      krita
    ]) ++ lib.optionals cfg.enableGaming (with pkgs; [
      # Gaming tools
      steam
      lutris
      gamemode
      mangohud
    ]) ++ lib.optionals hasIntelGPU (with pkgs; [
      intel-gpu-tools
    ]) ++ lib.optionals hasAMDGPU (with pkgs; [
      radeontop
    ]);

    # Gaming-specific configurations
    programs.steam.enable = lib.mkIf cfg.enableGaming true;
    programs.gamemode.enable = lib.mkIf cfg.enableGaming true;

    # Graphics hardware support
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Desktop services
    services = {
      dbus.enable = true;
      udisks2.enable = true;
      gvfs.enable = true;
    };

    # Font configuration
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        nerd-fonts.hack
        nerd-fonts.fira-code
        liberation_ttf
        dejavu_fonts
      ];
    };
  };
}
