{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules.guiPrograms.signal;
in
{
  options.myHomeModules.guiPrograms.signal = {
    enable = lib.mkEnableOption "Signal desktop messenger";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.signal-desktop ];
  };
}
