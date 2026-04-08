{ config, pkgs, lib, ... }:

{
  options.myHomeModules.cliPrograms.scripts = {
    enable = lib.mkEnableOption "Custom shell scripts (mailias, sermail)";
  };

  config = lib.mkIf config.myHomeModules.cliPrograms.scripts.enable {
    home.packages = [

      (pkgs.writeShellApplication {
        name = "mailias";
        runtimeInputs = with pkgs; [ coreutils wl-clipboard ];
        text = builtins.readFile ./scripts/create-email-alias.sh;
      })

      (pkgs.writeShellApplication {
        name = "sermail";
        runtimeInputs = with pkgs; [ coreutils wl-clipboard ];
        text = builtins.readFile ./scripts/create-service-email.sh;
      })
    ];
  };
}
