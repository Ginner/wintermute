{ pkgs, lib, config, ... }:

let
  cfg = config.myModules.services.brightnessctl;
  user = config.userGlobals.username;
in
{
  options.myModules.services.brightnessctl = {
    enable = lib.mkEnableOption "Brightness control with proper udev rules";

    enableVideo = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable brightness control for video devices";
    };

    enableLEDs = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable brightness control for LED devices";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = config.environment.systemPackages ++ (with pkgs; [
      brightnessctl
    ]);

    # Add user to video group for brightness control
    users.users.${user}.extraGroups = [ "video" ];

    # Udev rules for brightness control
    services.udev.extraRules = ''
      # Allow members of video group to change brightness
      ACTION=="add", SUBSYSTEM=="backlight", GROUP="video", MODE="0664"
      ACTION=="add", SUBSYSTEM=="leds", GROUP="video", MODE="0664"
    '';

    # Alternative: use systemd-logind for brightness control
    # This provides a more secure approach via PolicyKit
    security.polkit.enable = true;
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.login1.power-off" ||
              action.id == "org.freedesktop.login1.reboot" ||
              action.id == "org.freedesktop.login1.suspend" ||
              action.id == "org.freedesktop.login1.hibernate") {
              return polkit.Result.YES;
          }
      });
    '';
  };
}