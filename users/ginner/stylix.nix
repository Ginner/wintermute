{ pkgs, lib, ... }:
{
  stylix = {
    enable = true;
    image = ./wall.jpeg;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";
    cursor = {
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
}
