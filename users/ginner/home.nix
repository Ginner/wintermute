{ config, pkgs, inputs, lib, ... }:

{
  # Enable email services (infrastructure only — account config files written via sops templates)
  myHomeModules.services.email-accounts.enable = true;
  myHomeModules.tuiPrograms.neomutt.enable = true;
  myHomeModules.tuiPrograms.khard.enable = true;

  # sops-nix: key file, secrets, and config-file templates
  # Secrets are decrypted at login by the sops-nix systemd user service.
  # Config files for mbsync/msmtp/neomutt are written by sops templates —
  # secrets never appear in the Nix store.
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/email.yaml;

    secrets = {
      work-address     = {};
      work-realname    = {};
      work-rbw-key     = {};
      private-address  = {};
      private-realname = {};
      private-rbw-key  = {};
    };

    # mbsync config (~/.config/isyncrc)
    templates."isyncrc".path = "${config.xdg.configHome}/isyncrc";
    templates."isyncrc".content = ''
      IMAPAccount work
      CertificateFile /etc/ssl/certs/ca-certificates.crt
      Host imap.startmail.com
      PassCmd "${config.sops.placeholder.work-rbw-key}"
      Port 993
      TLSType IMAPS
      User ${config.sops.placeholder.work-address}

      IMAPStore work-remote
      Account work

      MaildirStore work-local
      Inbox ${config.xdg.dataHome}/mail/work/INBOX
      Path ${config.xdg.dataHome}/mail/work/
      SubFolders Verbatim

      Channel work
      Create Both
      Expunge Both
      Far :work-remote:
      Near :work-local:
      Patterns * !Spam
      Remove None
      SyncState *



      IMAPAccount private
      CertificateFile /etc/ssl/certs/ca-certificates.crt
      Host imap.startmail.com
      PassCmd "${config.sops.placeholder.private-rbw-key}"
      Port 993
      TLSType IMAPS
      User ${config.sops.placeholder.private-address}

      IMAPStore private-remote
      Account private

      MaildirStore private-local
      Inbox ${config.xdg.dataHome}/mail/private/INBOX
      Path ${config.xdg.dataHome}/mail/private/
      SubFolders Verbatim

      Channel private
      Create Both
      Expunge Both
      Far :private-remote:
      Near :private-local:
      Patterns * !Spam
      Remove None
      SyncState *
    '';

    # msmtp config (~/.config/msmtp/config)
    templates."msmtp-config".path = "${config.xdg.configHome}/msmtp/config";
    templates."msmtp-config".content = ''
      account work
      auth on
      from ${config.sops.placeholder.work-address}
      host smtp.startmail.com
      passwordeval ${config.sops.placeholder.work-rbw-key}
      port 465
      tls on
      tls_starttls off
      tls_trust_file /etc/ssl/certs/ca-certificates.crt
      user ${config.sops.placeholder.work-address}

      account private
      auth on
      from ${config.sops.placeholder.private-address}
      host smtp.startmail.com
      passwordeval ${config.sops.placeholder.private-rbw-key}
      port 465
      tls on
      tls_starttls off
      tls_trust_file /etc/ssl/certs/ca-certificates.crt
      user ${config.sops.placeholder.private-address}

      account default : work
    '';

    # neomutt per-account identity files (~/.config/neomutt/work, .../private)
    templates."neomutt-work".path = "${config.xdg.configHome}/neomutt/work";
    templates."neomutt-work".content = ''
      set ssl_force_tls = yes
      set certificate_file=/etc/ssl/certs/ca-certificates.crt

      # GPG section
      set crypt_autosign = no
      set crypt_opportunistic_encrypt = no
      set pgp_use_gpg_agent = yes
      set mbox_type = Maildir
      set sort = "threads"

      # MTA section
      set sendmail='msmtpq --read-envelope-from --read-recipients'

      # Sidebar
      set sidebar_visible = yes
      set sidebar_short_path = yes
      set sidebar_width = 28
      set sidebar_format = '%D%* %?F? %F? %?N?%N/?%?S?%S?'

      # MRA section
      set folder='${config.xdg.dataHome}/mail/work'
      set from='${config.sops.placeholder.work-address}'
      set postponed='+Drafts'
      set realname='${config.sops.placeholder.work-realname}'
      set record='+Sent'
      set spoolfile='+INBOX'
      set trash='+Trash'

      unset signature

      # notmuch section
      set nm_default_uri = "notmuch://${config.xdg.dataHome}/mail"
      virtual-mailboxes "My INBOX" "notmuch://?query=tag%3Ainbox"
    '';

    templates."neomutt-private".path = "${config.xdg.configHome}/neomutt/private";
    templates."neomutt-private".content = ''
      set ssl_force_tls = yes
      set certificate_file=/etc/ssl/certs/ca-certificates.crt

      # GPG section
      set crypt_autosign = no
      set crypt_opportunistic_encrypt = no
      set pgp_use_gpg_agent = yes
      set mbox_type = Maildir
      set sort = "threads"

      # MTA section
      set sendmail='msmtpq --read-envelope-from --read-recipients'

      # Sidebar
      set sidebar_visible = yes
      set sidebar_short_path = yes
      set sidebar_width = 28
      set sidebar_format = '%D%* %?F? %F? %?N?%N/?%?S?%S?'

      # MRA section
      set folder='${config.xdg.dataHome}/mail/private'
      set from='${config.sops.placeholder.private-address}'
      set postponed='+Drafts'
      set realname='${config.sops.placeholder.private-realname}'
      set record='+Sent'
      set spoolfile='+INBOX'
      set trash='+Trash'

      unset signature

      # notmuch section
      set nm_default_uri = "notmuch://${config.xdg.dataHome}/mail"
      virtual-mailboxes "My INBOX" "notmuch://?query=tag%3Ainbox"
    '';
  };

  # Ensure mbsync starts after sops-nix decrypts secrets at login
  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];

  # Git configuration (user-specific)
  programs.git.settings = {
    user = {
      name = "Ginner";
      email = "26798615+Ginner@users.noreply.github.com";
    };
  };

  # SSH configuration (user-specific)
  myHomeModules.cliPrograms.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/id_ed25519_sk";
      };
      "forgejo" = {
        hostname = "forgejo.ginnerskov.co";
        user = "git";
        port = 222;
        identityFile = "~/.ssh/id_ed25519_sk";
      };
      "codeberg" = {
        user = "git";
        hostname = "codeberg.org";
        identityFile = "~/.ssh/id_ed25519_sk";
      };
    };
  };

  # Enable OpenCode
  myHomeModules.tuiPrograms.opencode.enable = true;

  home.packages = with pkgs; [
    rbw
  ];
}
