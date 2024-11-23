{ pkgs, lib, ... }:
{
  stylix = {
    enable = true;
    image = ./wall.jpeg;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    cursor = {
      # package = pkgs.rose-pine-hyprcursor;
      # package = inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default;
      # name = "rose-pine-hyprcursor";
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
      size = 16;
    };
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "Hack" "FiraCode"]; };
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
  home.pointerCursor = lib.mkForce {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePine-Linux";
  };
}
