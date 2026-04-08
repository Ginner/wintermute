{ config, pkgs, lib, ... }:

let
  cfg = config.myHomeModules.tuiPrograms.khard;
in
{
  options.myHomeModules.tuiPrograms.khard = {
    enable = lib.mkEnableOption "khard contact management";
    
    contactsPath = lib.mkOption {
      type = lib.types.str;
      default = "${config.xdg.dataHome}/contacts";
      description = "Path to contacts directory";
    };
    
    # Placeholder for future CardDAV integration
    enableCardDAV = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable CardDAV sync (to be implemented)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.khard ];
    
    xdg.configFile."khard/khard.conf".text = ''
      [addressbooks]
      [[contacts]]
      path = ${cfg.contactsPath}/
      
      [general]
      editor = ${config.home.sessionVariables.EDITOR or "nvim"}
      merge_editor = ${config.home.sessionVariables.EDITOR or "nvim"}
      default_action = list
      show_nicknames = yes
    '';
    
    # Create contacts directory
    home.activation.createContactsDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${cfg.contactsPath}"
    '';
    
    # Future CardDAV sync with vdirsyncer will go here
    # systemd.user.services.vdirsyncer = lib.mkIf cfg.enableCardDAV { ... };
  };
}
