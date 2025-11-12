{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./cliPrograms
    ./guiPrograms
    ./tuiPrograms
    ./laptop.nix
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
    home.username = lib.mkDefault "ginner";
    home.homeDirectory = lib.mkDefault "/home/ginner";
    home.preferXdgDirectories = lib.mkDefault true;

    # Default packages for all users
    home.packages = config.home.packages ++ (with pkgs; [
      git
    ]);

    myHomeModules.cliPrograms.git.enable = lib.mkDefault true;
    myHomeModules.cliPrograms.ssh.enable = lib.mkDefault true;
    myHomeModules.cliPrograms.zsh.enable = lib.mkDefault true;

    home.sessionVariables = {
      EDITOR = lib.mkDefault "nvim";
    };

    programs.home-manager.enable = true;
  };
}
