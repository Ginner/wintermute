
{ pkgs, lib, config, ... }:

let
  cfg = config.myModules.services.pipewire;
in
{
  options.myModules.services.pipewire = {
    enable = lib.mkEnableOption "server for handling audio and video streams";

    alsaSupport = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable ALSA support";
    };

    alsaSupport32Bit = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable 32-bit ALSA support on 64-bit systems";
    };

    pulseEmulation = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable PulseAudio server emulation";
    };

    jackEmulation = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable JACK audio emulation";
    };
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = cfg.alsaSupport;
      alsa.support32Bit = cfg.alsaSupport32Bit;
      pulse.enable = cfg.pulseEmulation;
      jack.enable = cfg.jackEmulation;
    };
  };
}
