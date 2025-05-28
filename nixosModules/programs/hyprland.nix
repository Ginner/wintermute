{ config, pkgs, lib, inputs, ... }:

let
  cfg = config.myModules.programs.hyprland;
in
{
  options.myModules.programs.hyprland = {
    enable = lib.mkEnableOption "Hyprland window manager";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };

    myModules.services.xremap.withHypr = lib.mkDefault true;
  };
}

