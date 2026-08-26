{ config, pkgs, lib, ... }:

{
  options.myHomeModules.tuiPrograms.opencode = {
    enable = lib.mkEnableOption "AI coding assistant";
  };

  config = lib.mkIf config.myHomeModules.tuiPrograms.opencode.enable {
    programs.opencode = {
      enable = true;
      settings = {
        instructions = lib.mkBefore [
          "instructions/apex-os.md"
        ];
        permission = {
          "*" = "ask";
        };
      };
    };

    xdg.configFile."opencode/instructions/apex-os.md".source =
      ../../assets/default/opencode/global-instructions.md;
  };
}
