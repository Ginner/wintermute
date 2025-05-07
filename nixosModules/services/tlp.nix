{ pkgs, lib, config, ... }: {
  options.myModules.services.tlp = {
    enable = lib.mkEnableOption "TLP power management services for laptops";

    startChargeThreshBat0 = lib.mkOption {
      type = lib.types.int;
      default = 75;
      description = "Battery charge start threshold for BAT0";
    };

    stopChargeThreshBat0 = lib.mkOption {
      type = lib.types.int;
      default = 80;
      description = "Battery charge stop threshold for BAT0";
    };
  };

  config = lib.mkIf config.myModules.services.tlp.enable {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = toString config.myModules.services.tlp.startChargeThreshBat0;
      STOP_CHARGE_THRESH_BAT0 = toString config.myModules.services.tlp.stopChargeThreshBat0;
    };
  };
}
