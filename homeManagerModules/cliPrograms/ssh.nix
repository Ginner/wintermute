{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules.cliPrograms.ssh;
in
{
  options.myHomeModules.cliPrograms.ssh = {
    enable = lib.mkEnableOption "SSH client configuration";

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
      controlMaster = if cfg.enableControlMaster then "auto" else "no";
      controlPath = lib.mkIf cfg.enableControlMaster "~/.ssh/master-%r@%n:%p";
      controlPersist = lib.mkIf cfg.enableControlMaster "10m";
      extraConfig = cfg.extraConfig;
    };
  };
}