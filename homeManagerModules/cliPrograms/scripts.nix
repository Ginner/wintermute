{ config, pkgs, lib, ... }:

{
  home.packages = [

    (pkgs.writeShellApplication {
      name = "mailias";
      runtimeInputs = with pkgs; [ coreutils wl-clipboard ];
      text = builtins.readFile ./scripts/create-email-alias.sh ;
    })

    (pkgs.writeShellApplication {
      name = "sermail";
      runtimeInputs = with pkgs; [ coreutils wl-clipboard ];
      text = builtins.readFile ./scripts/create-service-email.sh ;
    })
  ];
}
