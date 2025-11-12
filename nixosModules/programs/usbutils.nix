{ pkgs, lib, config, ... }:

let
  cfg = config.myModules.programs.usbutils;
in
{
  options.myModules.programs.usbutils = {
    enable = lib.mkEnableOption "USB utilities (lsusb, usb-devices, etc.)";

    enableExtraTools = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable additional USB debugging tools";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = config.environment.systemPackages ++ (with pkgs; [
      usbutils
    ]) ++ lib.optionals cfg.enableExtraTools (with pkgs; [
      usbtop
      usbview
    ]);

    # Ensure proper permissions for USB device access
    services.udev.packages = [ pkgs.usbutils ];
  };
}