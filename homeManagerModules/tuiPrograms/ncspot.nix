{ config, pkgs, lib, ... }:

{
  options.myHomeModules.tuiPrograms.ncspot = {
    enable = lib.mkEnableOption "Terminal-based Spotify client";
  };

  config = lib.mkIf config.myHomeModules.tuiPrograms.ncspot.enable {
    programs.ncspot = {
      enable = true;
    };
  };
}
