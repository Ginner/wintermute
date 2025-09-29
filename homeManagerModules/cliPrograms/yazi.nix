{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules.cliPrograms.yazi;
in
{
  options.myHomeModules.cliPrograms.yazi = {
    enable = lib.mkEnableOption "Yazi terminal file manager";

    enableZshIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable zsh integration";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = cfg.enableZshIntegration;
      settings = {
        opener = {
          edit = [
            { run = ''kitty --detach nvim "$@"''; block = false; orphan = true; for = "linux"; }
          ];
          open = [
            { run = '' ${pkgs.xdg-utils}/bin/xdg-open "$1"''; block = false; orphan = true; }
          ];
        };
        open.rules = [
            { mime = "text/*"; use = [ "edit" "reveal" ]; }
          ];
      };
    };
    home.shellAliases = {
      y = "yazi";
    };
    stylix.targets.yazi.enable = true;
  };

}
