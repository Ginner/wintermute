{ config, pkgs, lib, ...}:
{
  options.myHomeModules.services.xdg = {
    enable = lib.mkEnableOption "enable xdg portals";
  };

  config = lib.mkIf config.myHomeModules.services.xdg.enable {
    xdg.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config = {
        common.default = [ "hyprland" "gtk" ];
      };
    };

    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
      download = "${config.home.homeDirectory}/INBOX";
      music = "${config.home.homeDirectory}/MEDIA/Music";
      videos = "${config.home.homeDirectory}/MEDIA/Videos";
      pictures = "${config.home.homeDirectory}/MEDIA/Pictures";
      desktop = null;
      documents = null;
      publicShare = null;
      templates = null;
    };
    
    xdg.desktopEntries.nvim = {
      name = "Neovim";
      genericName = "Text Editor";
      exec = "kitty -e nvim %F"; 
      terminal = false;
      type = "Application";
      categories = [ "Utility" "TextEditor" ];
      mimeType = [ "text/plain" "text/markdown" "application/x-shellscript" ];
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/*" = [ "nvim.desktop" ];
        "application/pdf" = [ "zathura.desktop" ];
        "image/*" = [ "swayimg.desktop" ];
        "video/*" = [ "mpv.desktop" ];
      };
      # Example. swayimg is already the default.
      associations.added = {
        "image/*" = [ "swayimg.desktop" ];
      };
    };
  };
}
