{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules.cliPrograms.ssh;
in
{
  options.myHomeModules.cliPrograms.ssh = {
    enable = lib.mkEnableOption "SSH client";

    enableControlMaster = lib.mkOption { type = lib.types.bool; default = false; };
    matchBlocks = lib.mkOption {
      type = lib.types.attrsOf (lib.types.anything);
      default = {};
      description = "Forwarded to programs.ssh.matchBlocks";
    };
    extraConfig = lib.mkOption { type = lib.types.lines; default = ""; };
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      extraConfig = cfg.extraConfig;
      matchBlocks =
        cfg.matchBlocks
        // lib.optionalAttrs cfg.enableControlMaster {
          "*" = {
            controlMaster  = "auto";
            controlPersist = "10m";
            controlPath    = "~/.ssh/cm-%C";
          };
        };
    };
  };
}

