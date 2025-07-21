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

    home.packages = with pkgs; [
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
      grim
      slurp
      wf-recorder
      swappy
      wl-clipboard
    ];
  };


  programs.yazi = {
    enable = true;
  };

}
