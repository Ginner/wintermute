{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.myModules.services.xremap;
  user = config.userGlobals.username;
in
{
  options.myModules.services.xremap = {
    enable = lib.mkEnableOption "xremap service";

    withHypr = lib.mkOption {
      type = lib.types.bool;
      default = config.myModules.programs.hyprland.enable or false;
      description = "Enable xremap for Hyprland";
    };

    modmaps = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "Name of the modmap.";
          };
          remap = lib.mkOption {
            type = lib.types.attrsOf (lib.types.anything);
            description = "Key remappings for the modmap.";
          };
        };
      });
      default = [];
      description = "List of modmaps to apply.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Extra configuration options for xremap.";
    };

    includeDefaults = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include the default CapsLock remap.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xremap = {
      enable = true;
      package = inputs.xremap-flake.packages."${pkgs.stdenv.hostPlatform.system}".default;
      withHypr = cfg.withHypr;
      watch = true;
      config = {
        modmap = (lib.optionals cfg.includeDefaults [
          {
            name = "main-remaps";
            remap = {
              "CapsLock" = { held = "Super_L"; alone = "Esc"; alone_timeout_millis = 200; };
            };
          }
        ])
        ++ cfg.modmaps;
      } // cfg.extraConfig;
    };
    users.users.${user}.extraGroups = [ "input" "uinput" ];
    hardware.uinput.enable = true; 
  };
}
