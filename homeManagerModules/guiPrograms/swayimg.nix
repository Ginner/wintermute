{ config, pkgs, lib, ... }:

let
  cfg = config.myHomeModules.guiPrograms.swayimg;
in
{
  options.myHomeModules.guiPrograms.swayimg = {
    enable = lib.mkEnableOption "Image viewer for Wayland";
  };

  config = lib.mkIf cfg.enable {
    home.packages = config.home.packages ++ (with pkgs; [
      swayimg
    ]);
  };
}

