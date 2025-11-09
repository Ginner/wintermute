{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ../../homeManagerModules
    inputs.nixvim.homeModules.nixvim
    inputs.ags.homeManagerModules.default
    inputs.walker.homeManagerModules.walker
  ];
  # Enable laptop home configuration
  myHomeModules.laptop.enable = true;

  # Override stylix wallpaper for BISHOP
  myHomeModules.guiPrograms.stylix.image = ../../assets/wall.jpeg;

  # Additional packages not covered by the bundles
  home.packages = with pkgs; [
  ];

  home.file = {
  };

  programs.git = {
    userName = "Ginner";
    userEmail = "26798615+Ginner@users.noreply.github.com";

    # To override default branchname (main):
    # extraConfig.init.defaultBranch = "trunk"; 
  };

  # Override SSH configuration with host-specific settings
  myHomeModules.cliPrograms.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/id_ed25519_sk";
      };
      "forgejo" = {
        hostname = "forgejo.ginnerskov.co";
        user = "git";
        port = 222;
        identityFile = "~/.ssh/id_ed25519_sk";
      };
    };
  };
  
  home.stateVersion = "22.11"; # Set based on when this host was installed
}
