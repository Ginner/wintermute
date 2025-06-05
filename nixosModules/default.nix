{ config, pkgs, lib, ... }:

let
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

  time.timezone = "Europe/Copenhagen";
  i18n.defaultLocale = "da_DK.UTF-8";
  i18n.extraLocaleSettings = {
    LANG = "en_DK.UTF-8";
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dk";
  };

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  programs.zsh.shellAliases = {
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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  services = {
    fwupd.enable = true;
    kmscon.enable = true;
  };
  security.rtkit.enable = true;

  config = lib.mkIf config.myModules.enable {
  # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${user} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
        trusted-users = [ "root" "myuser" ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };
  };
}
