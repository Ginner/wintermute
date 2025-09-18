{ config, pkgs, lib, ... }:

let
  cfg = config.myHomeModules.cliPrograms.archive-tools;
in
{
  options.myHomeModules.cliPrograms.archive-tools = {
    enable = lib.mkEnableOption "Archive and compression tools";

    enableAll = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable all archive tools";
    };

    zip.enable = lib.mkEnableOption "ZIP tools" // { default = cfg.enableAll; };
    p7zip.enable = lib.mkEnableOption "7-Zip tools" // { default = cfg.enableAll; };
    xz.enable = lib.mkEnableOption "XZ tools" // { default = cfg.enableAll; };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      lib.optionals cfg.zip.enable [ zip unzip ] ++
      lib.optionals cfg.p7zip.enable [ p7zip ] ++
      lib.optionals cfg.xz.enable [ xz ];
  };
}