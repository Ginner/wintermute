{ config, pkgs, lib, ... }:
{
  options.myHomeModules.guiPrograms.stylix = {
    enable = lib.mkEnableOption "Enable stylix theming for home-manager";

    image = lib.mkOption {
      type = lib.types.path;
      default = ../../assets/default.jpg;
      description = "Wallpaper image for theming";
    };
  };

  config = lib.mkIf config.myHomeModules.guiPrograms.stylix.enable {
    stylix = {
      enable = true;
      image = config.myHomeModules.guiPrograms.stylix.image;
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";
      cursor = {
        package = pkgs.rose-pine-cursor;
        name = "BreezeX-RosePine-Linux";
        size = 16;
      };
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.hack;
          name = "Hack Nerd Font Mono";
        };
        sizes = {
          terminal = 11;
          desktop = 11;
          applications = 11;
          popups = 14;
        };
      };
    };
  };
}
