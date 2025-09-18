{ config, pkgs, lib, ... }:

let
  cfg = config.myHomeModules.guiPrograms.mpv;
in
{
  options.myHomeModules.guiPrograms.mpv = {
    enable = lib.mkEnableOption "MPV media player";

    enableHardwareAcceleration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable hardware acceleration";
    };

    enableGpuRendering = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable GPU rendering";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.mpv = {
      enable = true;
      config = {
        hwdec = lib.mkIf cfg.enableHardwareAcceleration "auto";
        vo = lib.mkIf cfg.enableGpuRendering "gpu";
        profile = lib.mkIf cfg.enableGpuRendering "gpu-hq";
        scale = "ewa_lanczossharp";
        cscale = "ewa_lanczossharp";
      };
    };
  };
}