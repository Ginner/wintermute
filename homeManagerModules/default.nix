{ config, pkgs, inputs, lib, ... }:

let
  user = config.userGlobals.username;
in
{
  imports = [
    ./cliPrograms
    ./guiPrograms
  ];

  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
}
