{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.services.podman;
  user = config.userGlobals.username;
in
{
  options.myModules.services.podman = {
    enable = lib.mkEnableOption "Podman container engine";

    dockerCompat = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Docker compatibility";
    };

    enableDnsInDefaultNetwork = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable DNS in default network";
    };

    enableNvidia = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable NVIDIA GPU support in containers";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional packages to install with podman";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = cfg.dockerCompat;
      defaultNetwork.settings.dns_enabled = cfg.enableDnsInDefaultNetwork;
      enableNvidia = cfg.enableNvidia;
    };

    # Add user to podman group
    users.users.${user}.extraGroups = [ "podman" ];

    # Install additional container tools
    environment.systemPackages = config.environment.systemPackages ++ (with pkgs; [
      podman-compose
      buildah
      skopeo
    ]) ++ cfg.extraPackages;

    # Enable podman socket for docker-compose compatibility
    systemd.sockets.podman = lib.mkIf cfg.dockerCompat {
      wantedBy = [ "sockets.target" ];
    };
  };
}