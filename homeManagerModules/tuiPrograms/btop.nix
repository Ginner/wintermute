{ config, pkgs, lib, ... }:

{
  options.myHomeModules.cliPrograms.btop = {
    enable = lib.mkEnableOption "System monitor/manager";
  };

  config = lib.mkIf config.myHomeModules.cliPrograms.btop.enable {
    programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
        # color_theme = "gruvbox_dark_v2";
      };
    };
  };
}

