{ pkgs, lib, config, ... }:

let
  cfg = config.myModules.services.bolt;
  # Detect if system has Thunderbolt capability
  hasThunderbolt = builtins.pathExists "/sys/bus/thunderbolt" ||
                   builtins.any (device: lib.hasInfix "thunderbolt" (lib.toLower device))
                   (builtins.attrNames (config.hardware.deviceTree or {}));
in
{
  options.myModules.services.bolt = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = hasThunderbolt;
      description = "Enable Thunderbolt security management (auto-detected)";
    };

    authMode = lib.mkOption {
      type = lib.types.enum [ "disabled" "enabled" "secure" ];
      default = "secure";
      description = "Thunderbolt authorization mode";
    };
  };

  config = lib.mkIf cfg.enable {
    services.hardware.bolt = {
      enable = true;
    };

    environment.systemPackages = config.environment.systemPackages ++ (with pkgs; [
      bolt
    ]);

    # Set authorization mode if supported
    # Note: This may require additional configuration for specific auth modes
  };
}