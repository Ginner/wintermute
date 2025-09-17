{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./cliPrograms
    ./guiPrograms
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

    # Default packages for all users
    home.packages = with pkgs; [
      # Core CLI tools
      tree
      wget
      curl
      git
      unzip
      p7zip
      zip
      xz
      fd
      ripgrep
      fzf
      jq
    ];

    # Basic program configurations
    programs.direnv = {
      enable = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;
      nix-direnv.enable = lib.mkDefault true;
    };

    # Git configuration is handled by the git module
    myHomeModules.cliPrograms.git.enable = lib.mkDefault true;

    home.sessionVariables = {
      EDITOR = lib.mkDefault "nvim";
    };

    programs.home-manager.enable = true;
  };
}
