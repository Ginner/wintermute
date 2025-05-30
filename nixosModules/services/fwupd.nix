{ config, lib, pkgs, ... }:
let
  cfg = config.myModules.services.fwupd;
in
{
  options.myModules.services.fwupd = {
    enable = lib.mkEnableOption "Enable fwupd for managing firmware";
  };
  config = lib.mkIf cfg.enable {
    services.fwupd.enable = lib.mkDefault true;
  };
}

