{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.programs.zsh;
  user = config.userGlobals.username;
in
{
  options.myModules.programs.zsh = {
    enable = lib.mkEnableOption "Zsh shell system configuration";

    setAsDefaultShell = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Set zsh as the default shell";
    };

    enableCompletion = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable system-wide zsh completion";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable zsh system-wide
    programs.zsh = {
      enable = true;
      enableCompletion = cfg.enableCompletion;
      # System-level zsh configuration
      promptInit = ''
        # Basic prompt for system-level zsh
        PS1="%n@%m:%~%# "
      '';
    };

    # Set as default shell if requested
    users.defaultUserShell = lib.mkIf cfg.setAsDefaultShell pkgs.zsh;

    # Ensure user has zsh as their shell
    users.users.${user} = lib.mkIf cfg.setAsDefaultShell {
      shell = pkgs.zsh;
    };

    # System packages for zsh functionality
    environment.systemPackages = config.environment.systemPackages ++ (with pkgs; [
      zsh
      zsh-completions
    ]);
  };
}
