{ config, pkgs, inputs, lib, ... }:

let
  cfg = config.myHomeModules.laptop;
in
{
  imports = [
    ./guiPrograms/firefox.nix
    ./guiPrograms/hyprland.nix
  ];

  options.myHomeModules.laptop = {
    enable = lib.mkEnableOption "Laptop-specific home configuration";
  };

  config = lib.mkIf cfg.enable {
    # Enable laptop-specific home modules according to the table
    # Required applications
    myHomeModules.guiPrograms.firefox.enable = lib.mkDefault true;
    myHomeModules.guiPrograms.hyprland.enable = lib.mkDefault true;
    myHomeModules.guiPrograms.kitty.enable = lib.mkDefault true;
    myHomeModules.guiPrograms.zathura.enable = lib.mkDefault true;
    myHomeModules.guiPrograms.wayland-tools.enable = lib.mkDefault true;
    myHomeModules.cliPrograms.cli-tools.enable = lib.mkDefault true;
    myHomeModules.cliPrograms.starship.enable = lib.mkDefault true;
    myHomeModules.cliPrograms.archive-tools.enable = lib.mkDefault true;
    myHomeModules.cliPrograms.direnv.enable = lib.mkDefault true;

    # Optional applications (default = false per table)
    myHomeModules.guiPrograms.inkscape.enable = lib.mkDefault false;
    myHomeModules.guiPrograms.sxiv.enable = lib.mkDefault false;
    myHomeModules.guiPrograms.mpv.enable = lib.mkDefault false;
    myHomeModules.guiPrograms.kde-connect.enable = lib.mkDefault false;
    myHomeModules.guiPrograms.latex.enable = lib.mkDefault false;
    myHomeModules.cliPrograms.btop.enable = lib.mkDefault false;
    myHomeModules.cliPrograms.ncspot.enable = lib.mkDefault false;
    myHomeModules.cliPrograms.yazi.enable = lib.mkDefault false;

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

    programs.yazi = {
      enable = lib.mkDefault true;
    };

    # Disable stylix for waybar in laptop config
    stylix.targets.waybar.enable = false;
  };
}
