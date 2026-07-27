{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.myModules.services.scanning;

  airscanConfig = pkgs.writeTextDir "etc/sane.d/airscan.conf" ''
    [devices]
    ${lib.concatMapStringsSep "\n" (device: ''"${device.name}" = ${device.url}, ${device.protocol}'') cfg.devices}

    [options]
    discovery = ${if cfg.discovery then "enable" else "disable"}
  '';
in
{
  options.myModules.services.scanning = {
    enable = lib.mkEnableOption "SANE scanning with driverless AirScan support";

    discovery = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable automatic eSCL and WSD scanner discovery";
    };

    devices = lib.mkOption {
      default = [ ];
      description = "Statically configured AirScan devices";
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Name shown by SANE clients";
            };

            url = lib.mkOption {
              type = lib.types.str;
              example = "http://192.168.1.10/eSCL";
              description = "eSCL or WSD scanner endpoint";
            };

            protocol = lib.mkOption {
              type = lib.types.enum [
                "eSCL"
                "WSD"
              ];
              default = "eSCL";
              description = "Driverless scanning protocol";
            };
          };
        }
      );
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.sane = {
      enable = true;
      extraBackends = [
        pkgs.sane-airscan
        airscanConfig
      ];
    };
  };
}
