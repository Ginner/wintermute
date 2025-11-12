{ config, pkgs, lib, ...}:
{
  options.myHomeModules.services.xdg = {
    enable = lib.mkEnableOption "xdg desktop portals";
  };

  config = lib.mkIf config.myHomeModules.services.xdg.enable {
    xdg.enable = true;

    xdg.userDirs = {
      enable = true;
      createDirectories = true;
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
        "text/plain" = [ "nvim.desktop" ];
        "text/markdown" = [ "nvim.desktop" ];
        "application/pdf" = [ "zathura.desktop" ];
        "image/jpeg" = [ "swayimg.desktop" ];
        "image/png" = [ "swayimg.desktop" ];
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

