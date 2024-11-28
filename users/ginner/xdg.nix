{ config, pkgs, ...}:
{
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-wlr];
    config.hyprland = {
      default = ["wlr" "gtk"];
    };
  };

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

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "text/plain" = [ "neovide.desktop" ];
    "application/pdf" = [ "zathura.desktop" ];
    "image/jpeg" = [ "sxiv.desktop" ];
    "image/png" = [ "sxiv.desktop" ];
    "image/*" = [ "sxiv.desktop" ];
    "video/png" = [ "mpv.desktop" ];
    "video/jpg" = [ "mpv.desktop" ];
    "video/*" = [ "mpv.desktop" ];
  };
  xdg.mimeApps.associations.added = {
    "image/*" = [ "sxiv.desktop" ];
  };
}
