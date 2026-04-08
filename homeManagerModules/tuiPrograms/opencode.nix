{ config, pkgs, lib, ... }:

{
  options.myHomeModules.tuiPrograms.opencode = {
    enable = lib.mkEnableOption "AI coding assistant";
  };

  config = lib.mkIf config.myHomeModules.tuiPrograms.opencode.enable {
    programs.opencode = {
      enable = true;
      settings = {
        plugin = [
          "@ex-machina/opencode-anthropic-auth@1.1.1"
        ];
        permission = {
          "*" = "ask";
        };
      };
    };
  };
}
