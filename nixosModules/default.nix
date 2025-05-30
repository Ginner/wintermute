{ config, pkgs, lib, ... }:

{
  imports = [
    ./services/tlp.nix
    ./services/xremap.nix
    ./services/greetd.nix

    ./programs/

  ];

  networking.networkmanager.enable = true;
  time.timezone = "Europe/Copenhagen";
  i18n.defaultLocale = "da_DK.UTF-8";
  i18n.extraLocaleSettings = {
    LANG = "en_DK.UTF-8";
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dk";
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  security.rtkit.enable = true;
}
