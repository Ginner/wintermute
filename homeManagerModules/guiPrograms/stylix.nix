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
    # The NixOS-level stylix module (stylix.nixosModules.stylix in flake.nix)
    # manages stylix.enable and all system-level targets.
    # Here we only override HM-specific values that differ from the NixOS defaults.
    stylix.image = config.myHomeModules.guiPrograms.stylix.image;
  };
}
