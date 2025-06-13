{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules.kitty;
in
{
  options.myHomeModules.kitty = {
    enable = lib.mkEnableOption "Kitty terminal emulator";

    enableZshIntegration = lib.mkEnableOption "Enable Zsh shell integration for Kitty";

    extraConfig = lib.mkOption {
      type = lib.types.str;
      default = "
        window_padding_width 10
        ";
      description = "Extra configuration for Kitty terminal.";
    };
  };

  config = lib.mkIf cfg.enable {
    myHomeModules.kitty = {
      enable = true;
      enableZshIntegration = cfg.enableZshIntegration;
      extraConfig = cfg.extraConfig;
    };
  };
}
