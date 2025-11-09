{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules.guiPrograms.kitty;
in
{
  options.myHomeModules.guiPrograms.kitty = {
    enable = lib.mkEnableOption "Kitty terminal emulator";

    fontSize = lib.mkOption {
      type = lib.types.int;
      default = 11;
      description = "Font size for Kitty terminal";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = ''
        window_padding_width 10
      '';
      description = "Extra configuration for Kitty terminal";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font.size = cfg.fontSize;
      extraConfig = cfg.extraConfig;
    };
  };
}
