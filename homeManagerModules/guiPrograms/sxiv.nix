{ config, pkgs, lib, ... }:

let
  cfg = config.myHomeModules.guiPrograms.sxiv;
in
{
  options.myHomeModules.guiPrograms.sxiv = {
    enable = lib.mkEnableOption "Simple X Image Viewer";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      sxiv
    ];
  };
}