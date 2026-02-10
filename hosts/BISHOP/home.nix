{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ../../homeManagerModules
    ../../users/ginner/home.nix  # User-specific home-manager config
    inputs.nixvim.homeModules.nixvim
    inputs.ags.homeManagerModules.default
    inputs.walker.homeManagerModules.walker
  ];
  # Enable laptop home configuration
  myHomeModules.laptop.enable = true;

  # Override stylix wallpaper for BISHOP
  myHomeModules.guiPrograms.stylix.image = ../../assets/wall.jpeg;

  # Host-specific display configuration
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
  
  home.stateVersion = "22.11";
}
