{ config, lib, pkgs, ... }:
let
  cfg = config.myModules.services.tailscale;
in
{
  options.myModules.services.tailscale = {
    enable = lib.mkEnableOption "Enable tailscale overlay network";
  };
  config = lib.mkIf cfg.enable {
    services.tailscale.enable = lib.mkDefault true;
  };
}

