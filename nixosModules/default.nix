{ config, pkgs, lib, ... }:

let
  user = config.userGlobals.username;
in
{
  imports = [
    ./services/xremap.nix
    ./services/fwupd.nix
    ./services/tailscale.nix

  ];

  # options.userGlobals = {
  #   username = lib.mkOption {
  #     type = lib.types.str;
  #     default = "nixos";
  #     description = "The username for the default user.";
  #   };
  # };

  options.myModules = {
    # Global options that apply to all systems
    default = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable default system configuration";
      };
    };
    # Another way of creating an enable option
    home-manager = {
      enable = lib.mkEnableOption "Enable home-manager";
    };
  };

  config = lib.mkIf config.myModules.default.enable {
    # Default configurations for all systems
    users.users.${user} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };

    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
        trusted-users = [ "root" "@wheel" ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    time.timeZone = lib.mkDefault "Europe/Copenhagen";
    i18n.defaultLocale = lib.mkDefault "da_DK.UTF-8";
    i18n.extraLocaleSettings = {
      LANG = lib.mkDefault "en_DK.UTF-8";
    };
    console = {
      font = lib.mkDefault "Lat2-Terminus16";
      keyMap = lib.mkDefault "dk";
    };

    # Default packages for all systems
    environment.systemPackages = with pkgs; [
      git
      wget
      curl
      rsync
      tree
      file
      which
      unzip
      lm_sensors
    ];

    # Enable basic services
    services = {
      openssh.enable = true;
      fwupd.enable = true; # Firmware updates
    };

    # Basic security
    security.sudo.wheelNeedsPassword = true;
    
    # Enable zram swap
    # zramSwap = {
    #   enable = true;
    #   algorithm = "zstd";
    # };
    # Import neovim config instead
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
  };

}
