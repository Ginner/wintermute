{ config, pkgs, lib, ... }:

{
  options.myHomeModules.tuiPrograms.btop = {
    enable = lib.mkEnableOption "System monitor/manager";
  };

  config = lib.mkIf config.myHomeModules.tuiPrograms.btop.enable {
    programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
        # color_theme = "gruvbox_dark_v2";
      };
    };
  };
}

