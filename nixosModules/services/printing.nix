{ lib, config, ... }:

let
  cfg = config.myModules.services.printing;
  user = config.userGlobals.username;
in
{
  options.myModules.services.printing = {
    enable = lib.mkEnableOption "CUPS printing with mDNS printer discovery";

    drivers = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = ''
        Additional printer driver packages to make available to CUPS.
        Modern IPP-Everywhere/AirPrint network printers are driverless and
        do not need anything here; add drivers (e.g. `pkgs.hplip`,
        `pkgs.gutenprint`) only if a specific printer requires them.
      '';
    };
  };

  # No GUI package here by design. CUPS ships its own web admin UI
  # (http://localhost:631) with default = true, which covers adding/removing
  # printers, setting the default, and managing jobs — no extra package needed.
  config = lib.mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = cfg.drivers;
    };

    # Avahi provides mDNS/DNS-SD discovery so network printers (and
    # IPP-Everywhere/AirPrint-style driverless printers) show up
    # automatically when adding a printer, the same as on other OSes.
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # CUPS gates its web admin UI behind SystemGroup "root wheel lpadmin".
    # The primary user is already in "wheel" via the base module, but add
    # "lpadmin" explicitly so printer management works even if that ever
    # changes.
    users.users.${user}.extraGroups = [ "lpadmin" ];
  };
}
