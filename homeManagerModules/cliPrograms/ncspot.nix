{ config, pkgs, lib, ... }:

{
  options.myHomeModules.cliPrograms.ncspot = {
    enable = lib.mkEnableOption "Terminal-based Spotify client";
  };

  config = lib.mkIf config.myHomeModules.cliPrograms.ncspot.enable {
    programs.ncspot = {
      enable = true;
    };
  };
}
