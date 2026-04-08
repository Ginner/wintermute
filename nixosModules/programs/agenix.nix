{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.myModules.programs.agenix;
in
{
  options.myModules.programs.agenix = {
    enable = lib.mkEnableOption "Agenix secret management CLI";

    installCLI = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the agenix CLI tool for managing secrets";
    };
  };

  config = lib.mkIf cfg.enable {
    # Install the agenix CLI package
    environment.systemPackages = lib.optionals cfg.installCLI [
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
