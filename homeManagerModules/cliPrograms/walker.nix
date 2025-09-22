{ config, pkgs, lib, ... }:

{
  options.myHomeModules.cliPrograms.walker = {
    enable = lib.mkEnableOption "Application launcher (like rofi)";
  };

  config = lib.mkIf config.myHomeModules.cliPrograms.walker.enable {
    # Walker package installation
    home.packages = [
      pkgs.walker
    ];

    # Walker configuration file
    home.file.".config/walker/config.json".text = builtins.toJSON {
      search.placeholder = "...";
      ui.fullscreen = true;
      list = { height = 200; };
      websearch.prefix = "?";
      switcher.prefix = "/";
    };
  };
}
