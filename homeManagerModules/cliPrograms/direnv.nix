{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules.cliPrograms.direnv;
in
{
  options.myHomeModules.cliPrograms.direnv = {
    enable = lib.mkEnableOption "Direnv for per-directory environments";

    enableZshIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable zsh integration";
    };

    enableNixDirenv = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable nix-direnv for better Nix support";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = cfg.enableZshIntegration;
      nix-direnv.enable = cfg.enableNixDirenv;
    };
  };
}