{ config, pkgs, lib, . }:

{
  imports = [
    ./services/tlp.nix
    ./services/xremap.nix

    ./programs/

  ];
}
