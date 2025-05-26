
{ pkgs, lib, config, ... }: 

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

  config = lib.mkIf config.myModules.services.pipewire.enable {
    enable = true;
    alsa.enable = config.myModules.services.pipewire.alsaSupport;
    alsa.support32Bit = config.myModules.services.pipewire.alsaSupport32Bit;
    pulse.enable = config.myModules.services.pipewire.pulseEmulation;
    jack.enable = config.myModules.services.pipewire.jackEmulation;
  };
}
