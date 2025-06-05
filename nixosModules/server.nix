{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.server;
in
{
  options.myModules.server = {
    enable = lib.mkEnableOption "Server-specific system configurations";
    enableGreetd = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable greetd for login management";
    };

  };


  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
    {
      environment.systemPackages = with pkgs; [
        git
      ];
    }
    {
      services.openssh.enable = true;
    }
  ]);
}
