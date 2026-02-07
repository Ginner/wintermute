{ config, pkgs, lib, ... }:

{
  options.myHomeModules.tuiPrograms.opencode = {
    enable = lib.mkEnableOption "AI coding assistant";
  };

  config = lib.mkIf config.myHomeModules.tuiPrograms.opencode.enable {
    home.packages = [
      pkgs.opencode
    ];
    home.file.".config/opencode/opencode.json".text = builtins.toJSON {
      "$schema"= "https://opencode.ai/config.json";
      "permission"= {
        "*"= "ask";
      };
    };
  };
}
