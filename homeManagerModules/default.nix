{
  config,
  pkgs,
  inputs,
  lib,
  username ? "nixos",
  ...
}:

{
  imports = [
    ./cleanup.nix
    ./cliPrograms
    ./guiPrograms
    ./services
    ./tuiPrograms
    ./laptop.nix
    ./desktop.nix
  ];

  options.myHomeModules = {
    # Global options that apply to home-manager
    default = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable default home-manager configuration";
      };
    };
  };

  config = lib.mkIf config.myHomeModules.default.enable {
    home.username = lib.mkDefault username;
    home.homeDirectory = lib.mkDefault "/home/${username}";
    home.preferXdgDirectories = lib.mkDefault true;

    # Default packages for all users
    home.packages = with pkgs; [
      git
    ];

    myHomeModules.cliPrograms.git.enable = lib.mkDefault true;
    myHomeModules.cliPrograms.ssh.enable = lib.mkDefault true;
    myHomeModules.cliPrograms.zsh.enable = lib.mkDefault true;

    # Stylix defines `home.pointerCursor.*` without setting `enable`, which
    # home-manager deprecates. Set it explicitly to match stylix's intent.
    home.pointerCursor.enable = lib.mkDefault (
      (config.stylix.enable or false) && (config.stylix.cursor or null) != null
    );

    home.sessionVariables = {
      EDITOR = lib.mkDefault "nvim";
      NPM_CONFIG_CACHE = lib.mkDefault "${config.xdg.cacheHome}/npm";
    };

    programs.home-manager.enable = true;
  };
}
