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
  home.packages = config.home.packages ++ (with pkgs; [
  ]);

  home.file = {
  };

  services.kanshi.settings = [
    { 
      profile.name = "undocked";
      profile.outputs = [
        { criteria = "eDP-1"; scale = 1.2; status = "enable"; }
      ];
      profile.exec = "brightnessctl set 40%";
    }
    { 
      profile.name = "office";
      profile.outputs = [
        { criteria = "eDP-1"; position = "0,0"; scale = 1.0; } # Remember, scale applies to size-coordinates
        { criteria = "Dell Inc. DELL U2717D T4F1X87A735S"; position = "1920,-240"; scale = 1.00; }
        { criteria = "Dell Inc. DELL U2417H 5K9YD734A3ES"; position = "4480,-290"; scale = 1.00; transform = "270"; }
      ];
      profile.exec = "brightnessctl set 75%";
    }
  ];


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
