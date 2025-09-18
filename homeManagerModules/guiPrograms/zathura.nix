{ config, pkgs, lib, ... }:

let
  cfg = config.myHomeModules.guiPrograms.zathura;
in
{
  options.myHomeModules.guiPrograms.zathura = {
    enable = lib.mkEnableOption "Zathura PDF viewer";

    enableRecolor = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable automatic recoloring for dark themes";
    };

    enableClipboard = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable clipboard integration";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      options = {
        selection-clipboard = lib.mkIf cfg.enableClipboard "clipboard";
        recolor = cfg.enableRecolor;
        recolor-keephue = cfg.enableRecolor;
      };
    };
  };
}