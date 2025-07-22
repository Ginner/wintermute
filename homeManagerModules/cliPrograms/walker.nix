{ config, pkgs, lib, ... }:

{
  options.myHomeModules.walker = {
    enable = lib.mkEnableOption "Application launcher (like rofi)";
  };

  config = lib.mkIf config.myHomeModules.walker.enable {
    # Read off of here: https://github.com/scoiatael/dotfiles/blob/7ef8a8e90742e27cceb0c496f473cad2a5b55c53/modules/walker.nix
    programs.walker = {
      package = pkgs.walker;
      enable = true;
      runAsService = true;

      # All options from the config.json can be used here.
      config = {
        search.placeholder = "...";
        ui.fullscreen = true;
        list = { height = 200; };
        websearch.prefix = "?";
        switcher.prefix = "/";
      };

    # If this is not set the default styling is used.
    # style = ''
    #   * {
    #     color: #dcd7ba;
    #   }
    # '';
    # home.packages = [
    #   pkgs.walker
    # ];
    # home.file.".config/walker/config.toml".text = ''
    # # Your walker configuration in TOML or JSON here
    # '';
    };
  };
}
