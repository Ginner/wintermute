{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.myModules.programs.sops;
in
{
  options.myModules.programs.sops = {
    enable = lib.mkEnableOption "sops secret management CLI";

    installCLI = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the sops CLI tool for managing secrets";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = lib.optionals cfg.installCLI [
      pkgs.sops
    ];
  };
}
