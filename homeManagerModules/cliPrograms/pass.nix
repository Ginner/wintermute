{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules.cliPrograms.pass;
in
{
  options.myHomeModules.cliPrograms.pass = {
    enable = lib.mkEnableOption "pass password manager";

    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs.passExtensions; [ pass-otp ];
      description = "pass extensions to enable. Defaults to pass-otp for TOTP support.";
    };

    storeDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.xdg.dataHome}/password-store";
      description = "Path to the password store directory.";
    };

    extraSettings = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Additional environment variables passed to pass (see pass(1) for the full list).";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.password-store = {
      enable = true;
      package = pkgs.pass-wayland.withExtensions (_: cfg.extensions);
      settings = {
        PASSWORD_STORE_DIR = cfg.storeDir;
      } // cfg.extraSettings;
    };

    services.pass-secret-service = {
      enable = true;
      storePath = cfg.storeDir;
    };
  };
}
