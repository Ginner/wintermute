{ config, pkgs, lib, inputs, ... }:

{
  options.myHomeModules.guiPrograms.ags = {
    enable = lib.mkEnableOption "Aylur's GTK Shell widget system";
  };

  config = lib.mkIf config.myHomeModules.guiPrograms.ags.enable {
    programs.ags = {
      enable = true;
      configDir = ./ags;
      extraPackages = with pkgs; [
        inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.battery
        fzf
      ];
    };
  };
}
