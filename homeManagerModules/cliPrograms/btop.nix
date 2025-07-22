{ config, pkgs, lib, ... }:

{
  options.myHomeModules.btop = {
    enable = lib.mkEnableOption "System monitor/manager";
  };

  config = lib.mkIf config.myHomeModules.btop.enable {
    programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
        # color_theme = "gruvbox_dark_v2";
      };
    };
  };
}

