{ config, pkgs, inputs, lib, ... }:

let
  cfg = config.myHomeModules.laptop;
in
{
  imports = [
    ./guiPrograms
    ./tuiPrograms
    ./cliPrograms
  ];

  options.myHomeModules.laptop = {
    enable = lib.mkEnableOption "Laptop-specific home configuration";
  };

  config = lib.mkIf cfg.enable {
    # Enable laptop-specific home modules according to the table
    # Required applications
    myHomeModules.guiPrograms.firefox.enable = lib.mkDefault true;
    myHomeModules.guiPrograms.hyprland.enable = lib.mkDefault true;
    myHomeModules.cliPrograms.kitty.enable = lib.mkDefault true;
    myHomeModules.guiPrograms.zathura.enable = lib.mkDefault true;
    myHomeModules.guiPrograms.wayland-tools.enable = lib.mkDefault true;
    myHomeModules.guiPrograms.stylix.enable = lib.mkDefault true;
    myHomeModules.cliPrograms.kanshi.enable = lib.mkDefault true;
    myHomeModules.guiPrograms.sxiv.enable = lib.mkDefault true;
    myHomeModules.guiPrograms.mpv.enable = lib.mkDefault true;
    myHomeModules.tuiPrograms.btop.enable = lib.mkDefault true;
    myHomeModules.cliPrograms.cli-tools.enable = lib.mkDefault true;
    myHomeModules.cliPrograms.starship.enable = lib.mkDefault true;
    myHomeModules.cliPrograms.archive-tools.enable = lib.mkDefault true;
    myHomeModules.cliPrograms.direnv.enable = lib.mkDefault true;
    myHomeModules.guiPrograms.walker.enable = lib.mkDefault true;
    myHomeModules.tuiPrograms.yazi.enable = lib.mkDefault true;

    # Optional applications (default = false per table)
    myHomeModules.guiPrograms.inkscape.enable = lib.mkDefault false;
    myHomeModules.guiPrograms.kde-connect.enable = lib.mkDefault false;
    myHomeModules.cliPrograms.latex.enable = lib.mkDefault false;
    myHomeModules.tuiPrograms.ncspot.enable = lib.mkDefault false;

    home.packages = with pkgs; [
      # Laptop-specific tools not covered by modules
      inputs.taskfinder.packages.${pkgs.system}.default
      newsboat  # Could be made into module
      numbat    # Could be made into module
      pass-wayland
      calcurse  # Could be made into module
      khard     # Could be made into module
      imagemagick
      cheat     # Could be made into module
      ffmpegthumbnailer
      poppler
    ];

    # Disable stylix for waybar in laptop config
    stylix.targets.waybar.enable = false;

    # Enable ssh connection multiplexing
    myHomeModules.cliPrograms.ssh.enableControlMaster = true;
  };
}
