{ config, pkgs, lib, inputs, ... }:

{
  options.myHomeModules.cliPrograms.walker = {
    enable = lib.mkEnableOption "Application launcher";
  };

  config = lib.mkIf config.myHomeModules.cliPrograms.walker.enable {
    # # Walker package installation
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


    # home.packages = [
    #   inputs.walker.packages.${pkgs.system}.default
    # ];
    #
    # programs.walker = {
    #   enable = true;
    #   runAsService = true;
    #   config = {
    #     placeholders."search".input = "...";
    #     providers.prefixes = [
    #       {provider = "websearch"; prefix = "?";}
    #       {provider = "providerlist"; prefix = "_";}
    #     ];
    #
    #   };
    # };
    # systemd.user.services.elephant = {
    #   Unit = {
    #     After = [ "graphical-session.target" ];
    #   };
    # };

  };
}
