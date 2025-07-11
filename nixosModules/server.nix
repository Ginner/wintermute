{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.server;
in
{
  options.myModules.server = {
    enable = lib.mkEnableOption "Server-specific system configurations";

    enablePodman = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable podman for container management";
    };

  };


  config = lib.mkIf cfg.enable {
    # Fill in when relevant
    environment.systemPackages = with pkgs; [
    ];
    services.openssh.enable = true;
  };
}
