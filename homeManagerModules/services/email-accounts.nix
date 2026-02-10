{ config, pkgs, lib, ... }:

let
  cfg = config.myHomeModules.services.email-accounts;
in
{
  options.myHomeModules.services.email-accounts = {
    enable = lib.mkEnableOption "email account configuration";
  };

  config = lib.mkIf cfg.enable {
    # Set base maildir path using XDG
    accounts.email.maildirBasePath = "${config.xdg.dataHome}/mail";
    
    # Account definitions now come from user configs
    # Users define their own accounts.email.accounts.* in their home.nix
    
    # Enable programs globally when email is enabled
    programs.mbsync.enable = true;
    programs.msmtp.enable = true;
    
    # Configure notmuch database
    programs.notmuch = {
      enable = true;
      new.tags = [ "unread" "inbox" ];
      new.ignore = [ ".mbsyncstate" ".uidvalidity" ];
      search.excludeTags = [ "deleted" "spam" ];
      maildir.synchronizeFlags = true;
    };
    
    # Notmuch systemd timers are auto-created by Home Manager
    # per-account when accounts.email.accounts.<name>.notmuch.enable = true
  };
}
