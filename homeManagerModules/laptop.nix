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
    # Enable laptop-specific home modules
    myHomeModules.guiPrograms.firefox.enable = lib.mkDefault true;
    myHomeModules.guiPrograms.hyprland.enable = lib.mkDefault true;
    myHomeModules.cliPrograms.btop.enable = lib.mkDefault true;
    myHomeModules.cliPrograms.starship.enable = lib.mkDefault true;

    home.packages = with pkgs; [
      # Laptop-specific tools
      inputs.taskfinder.packages.${pkgs.system}.default
      zathura
      newsboat
      numbat
      bat
      pass-wayland
      sxiv
      mpv
      calcurse
      khard
      imagemagick
      inkscape
      cheat
      ffmpegthumbnailer

      # Screenshot and recording tools
      grim
      slurp
      wf-recorder
      swappy
      wl-clipboard

      # System monitoring
      brightnessctl
    ];

    programs.yazi = {
      enable = lib.mkDefault true;
    };

    services.mako = {
      enable = lib.mkDefault true;
    };

    # Disable stylix for waybar in laptop config
    stylix.targets.waybar.enable = false;
  };
}
