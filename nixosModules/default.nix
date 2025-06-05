{ config, pkgs, lib, ... }:

let
  cfg = config.myModules.default;
  user = config.userGlobals.username;
in
{
  imports = [
    ./services/tlp.nix
    ./services/xremap.nix
    ./services/greetd.nix

    ./programs/

  ];

  options.userGlobals = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = "The username for the default user.";
    };
  };

  options.myModules.default = {
    enable = lib.mkEnableOption "Enable the default system configuration.";
    enableZsh = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Zsh as the default shell.";
    };
    enableZshAliases = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Zsh aliases.";
    };
    setTimezone = lib.mkOption {
      type = lib.types.str;
      default = "Europe/Copenhagen";
      description = "Set the system timezone.";
    };
    setLocale = lib.mkOption {
      type = lib.types.str;
      default = "da_DK.UTF-8";
      description = "Set the system locale.";
    };
    setConsoleFont = lib.mkOption {
      type = lib.types.str;
      default = "Lat2-Terminus16";
      description = "Set the console font.";
    };
    setKeyMap = lib.mkOption {
      type = lib.types.str;
      default = "dk";
      description = "Set the console keymap.";
    };
    enableNeovim = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Neovim as the default editor.";
    };

    # Make services toggleable
    enableFwupd = lib.mkEnableOption "Enable fwupd service for firmware updates." // { default = true; };
    enableKmscon = lib.mkEnableOption "Enable kmscon for console management." // { default = true; };

    # Make available packages toggleable
    addFile = lib.mkEnableOption "Add the file program (shows filetype)." // { default = true; };
    addGawk = lib.mkEnableOption "Add GNU Awk." // { default = true; };
    addRsync = lib.mkEnableOption "Add rsync." // { default = true; };
    addSensors = lib.mkEnableOption "Add lm_sensors for hardware monitoring." // { default = true; };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.${user} = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };
      nix = {
        settings = {
          experimental-features = [ "nix-command" "flakes" ];
          auto-optimise-store = true;
          trusted-users = [ "root" "@wheel" ];
        };
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 30d";
        };
      };
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      time.timezone = cfg.setTimezone;
      i18n.defaultLocale = cfg.setLocale;
      i18n.extraLocaleSettings = {
        LANG = cfg.setLocale;
      };
      console = {
        font = cfg.setConsoleFont;
        keyMap = cfg.setKeyMap;
      };
    }
    (lib.mkIf cfg.enableFwupd { services.fwupd.enable = true; })
    (lib.mkIf cfg.enableKmscon { services.kmscon.enable = true; })

    (lib.mkIf cfg.addFile { environment.systemPackages = [ pkgs.file ]; })
    (lib.mkIf cfg.addGawk { environment.systemPackages = [ pkgs.gawk ]; })
    (lib.mkIf cfg.addRsync { environment.systemPackages = [ pkgs.rsync ]; })
    (lib.mkIf cfg.addSensors { environment.systemPackages = [ pkgs.lm_sensors ]; })

    (lib.mkIf cfg.enableZsh {
      users.defaultUserShell = pkgs.zsh;
      programs.zsh = {
        enable = true;
        shellAliases = lib.mkIf cfg.enableZshAliases {
          la = "ls -lAh --color=auto";
          ll = "ls -lh --color=auto";
          cp = "cp -riv";
          mv = "mv -iv";
          rm = "rm -I";
          mkdir = "mkdir -vp";
          grep = "grep --color=auto";
          fgrep = "fgrep --color=auto";
          egrep = "egrep --color=auto";
        };
      };
    })
    (lib.mkIf cfg.enableNeovim {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
      };
    })
  ]);
}
