{ config, pkgs, lib, ... }:

{
  options.myHomeModules.cliPrograms.starship = {
    enable = lib.mkEnableOption "Starship shell prompt customization";
  };

  config = lib.mkIf config.myHomeModules.cliPrograms.starship.enable {
    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = true;
      };
    };
  };
}
