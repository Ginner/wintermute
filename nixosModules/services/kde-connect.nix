{ pkgs, lib, config, ... }:

let
  cfg = config.myModules.services.kde-connect;
in
{
  options.myModules.services.kde-connect = {
    enable = lib.mkEnableOption "KDE Connect firewall support";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open firewall ports for KDE Connect";
    };

    indicatorPort = lib.mkOption {
      type = lib.types.int;
      default = 1716;
      description = "KDE Connect indicator port";
    };

    portRange = {
      min = lib.mkOption {
        type = lib.types.int;
        default = 1714;
        description = "Minimum port in KDE Connect range";
      };
      max = lib.mkOption {
        type = lib.types.int;
        default = 1764;
        description = "Maximum port in KDE Connect range";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Open firewall ports for KDE Connect
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPortRanges = [
        { from = cfg.portRange.min; to = cfg.portRange.max; }
      ];
      allowedUDPPortRanges = [
        { from = cfg.portRange.min; to = cfg.portRange.max; }
      ];
      allowedTCPPorts = [ cfg.indicatorPort ];
      allowedUDPPorts = [ cfg.indicatorPort ];
    };

    # Enable necessary services for KDE Connect to work properly
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = cfg.openFirewall;
    };
  };
}