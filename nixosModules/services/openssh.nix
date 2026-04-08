{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.services.openssh;
in
{
  options.myModules.services.openssh = {
    enable = lib.mkEnableOption "OpenSSH daemon";

    passwordAuthentication = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable password authentication";
    };

    permitRootLogin = lib.mkOption {
      type = lib.types.enum [ "yes" "no" "prohibit-password" ];
      default = "no";
      description = "Root login setting";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open firewall for SSH";
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = cfg.passwordAuthentication;
        PermitRootLogin = cfg.permitRootLogin;
      };
      openFirewall = cfg.openFirewall;
    };
  };
}