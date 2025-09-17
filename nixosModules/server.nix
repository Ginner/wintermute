{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.server;
  user = config.userGlobals.username;
in
{
  imports = [
    ./services/tailscale.nix
  ];

  options.myModules.server = {
    enable = lib.mkEnableOption "Server-specific system configurations";

    enableContainers = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable container runtime (Podman)";
    };

    enableWebServer = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable web server stack (nginx)";
    };

    enableDatabase = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable database services (PostgreSQL)";
    };

    enableMonitoring = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable monitoring tools";
    };

    enableBackups = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable backup utilities";
    };

    enableFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable and configure firewall";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable server-specific services through module options
    myModules.services.tailscale.enable = lib.mkDefault true;

    # Server packages
    environment.systemPackages = with pkgs; [
      # System administration tools
      htop
      iotop
      lsof
      netstat-nat
      tcpdump
      tmux
      screen

      # Monitoring tools
    ] ++ lib.optionals cfg.enableMonitoring [
      prometheus-node-exporter
      grafana-agent
    ] ++ lib.optionals cfg.enableBackups [
      restic
      rclone
      borgbackup
    ] ++ lib.optionals cfg.enableContainers [
      podman-compose
    ];

    # Core server services
    services = {
      openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
        };
      };

      # Container runtime
      podman = lib.mkIf cfg.enableContainers {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      # Web server
      nginx = lib.mkIf cfg.enableWebServer {
        enable = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
      };

      # Database
      postgresql = lib.mkIf cfg.enableDatabase {
        enable = true;
        enableTCPIP = true;
        authentication = ''
          local all all trust
          host all all 127.0.0.1/32 trust
          host all all ::1/128 trust
        '';
      };

      # Monitoring
      prometheus.exporters.node = lib.mkIf cfg.enableMonitoring {
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
    };

    # Container user configuration
    users.users.${user} = lib.mkIf cfg.enableContainers {
      extraGroups = [ "podman" ];
    };

    # Firewall configuration
    networking.firewall = lib.mkIf cfg.enableFirewall {
      enable = true;
      allowedTCPPorts = [ 22 ]  # SSH
        ++ lib.optionals cfg.enableWebServer [ 80 443 ]  # HTTP/HTTPS
        ++ lib.optionals cfg.enableMonitoring [ 9100 ];  # Node exporter
    };

    # Security hardening
    security = {
      sudo.wheelNeedsPassword = true;
      protectKernelImage = true;
    };

    # Automatic updates for servers
    system.autoUpgrade = {
      enable = lib.mkDefault false;  # Disabled by default for stability
      flake = "/etc/nixos";
      flags = [
        "--update-input"
        "nixpkgs"
        "-L"
      ];
      dates = "04:00";
      randomizedDelaySec = "45min";
    };

    # Disable GUI services for servers
    services.xserver.enable = lib.mkForce false;
    programs.hyprland.enable = lib.mkForce false;
  };
}
