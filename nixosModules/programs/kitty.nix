{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.programs.kitty;
in
{
  options.myModules.programs.kitty = {
    enable = lib.mkEnableOption "Kitty terminal emulator";

    extraConfig = lib.mkOption {
      type = lib.types.str;
      default = "
        window_padding_width 10
        ";
      description = "Extra configuration for Kitty terminal.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      extraConfig = cfg.extraConfig;
    };
  };
}
