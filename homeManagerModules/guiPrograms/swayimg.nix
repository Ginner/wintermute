{ config, pkgs, lib, ... }:

let
  cfg = config.myHomeModules.guiPrograms.swayimg;
in
{
  options.myHomeModules.guiPrograms.swayimg = {
    enable = lib.mkEnableOption "Image viewer for Wayland";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      swayimg
    ];

    xdg.configFile."swayimg/init.lua".text = ''
      local function quit()
        swayimg.exit()
      end

      swayimg.viewer.on_key("q", quit)
      swayimg.gallery.on_key("q", quit)
    '';
  };
}
