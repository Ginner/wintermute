{ config, pkgs, lib, ... }:

let
  cfg = config.myHomeModules.services.email-accounts;
in
{
  options.myHomeModules.services.email-accounts = {
    enable = lib.mkEnableOption "email toolchain (mbsync, msmtp, notmuch)";
  };

  config = lib.mkIf cfg.enable {
    # Account config files (isyncrc, msmtp/config, neomutt/work, neomutt/private)
    # are written by sops templates in the user's home.nix — not generated here.
    # This module only enables the programs so their packages and baseline config
    # are present.

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
  };
}
