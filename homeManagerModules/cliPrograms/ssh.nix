{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules.cliPrograms.ssh;
in
{
  options.myHomeModules.cliPrograms.ssh = {
    enable = lib.mkEnableOption "SSH client configuration";
    matchBlocks = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          user = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
          identityFile = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
        };
      });
    };

    enableControlMaster = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable SSH connection multiplexing";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra SSH client configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = cfg.matchBlocks // {
        "*" = {
          controlMaster = if cfg.enableControlMaster then "auto" else "no";
          controlPersist = lib.mkIf cfg.enableControlMaster "10m";
          controlPath = lib.mkIf cfg.enableControlMaster "~/.ssh/master-%r@%n:%p";
        };
      };
      extraConfig = cfg.extraConfig;
    };
  };
}
