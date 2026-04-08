{ config, pkgs, lib, ... }:

let
  cfg = config.myHomeModules.guiPrograms.inkscape;
in
{
  options.myHomeModules.guiPrograms.inkscape = {
    enable = lib.mkEnableOption "Inkscape vector graphics editor";

    enableExtensions = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable additional Inkscape extensions";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      inkscape
    ] ++ lib.optionals cfg.enableExtensions [
      # Add common extensions if available
      python3Packages.lxml  # Required for many extensions
    ];
  };
}