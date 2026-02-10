{ config, pkgs, inputs, lib, ... }:

let
  # Helper function to read secrets and strip newlines
  readSecret = path: lib.removeSuffix "\n" (builtins.readFile path);
in
{
  # Import user-specific secrets
  age.secrets = {
    email-work-address.file = ./.secrets/email-work-address.age;
    email-work-realname.file = ./.secrets/email-work-realname.age;
    email-work-rbw-key.file = ./.secrets/email-work-rbw-key.age;
    email-private-address.file = ./.secrets/email-private-address.age;
    email-private-realname.file = ./.secrets/email-private-realname.age;
    email-private-rbw-key.file = ./.secrets/email-private-rbw-key.age;
  };

  # Enable email services (infrastructure only, accounts defined below)
  myHomeModules.services.email-accounts.enable = true;
  myHomeModules.tuiPrograms.neomutt.enable = true;
  myHomeModules.tuiPrograms.khard.enable = true;

  # Define email accounts with encrypted data
  accounts.email.accounts = {
    "work" = {
      primary = true;
      address = readSecret config.age.secrets.email-work-address.path;
      userName = readSecret config.age.secrets.email-work-address.path;
      realName = readSecret config.age.secrets.email-work-realname.path;
      passwordCommand = "rbw get '${readSecret config.age.secrets.email-work-rbw-key.path}'";
      
      imap = {
        host = "imap.startmail.com";
        port = 993;
        tls.enable = true;
      };
      
      smtp = {
        host = "smtp.startmail.com";
        port = 465;
        tls = {
          enable = true;
          useStartTls = false;  # Port 465 uses implicit TLS
        };
      };
      
      folders = {
        inbox = "INBOX";
        sent = "Sent";
        drafts = "Drafts";
        trash = "Trash";
        junk = "Junk";
      };
      
      neomutt = {
        enable = true;
        extraMailboxes = [ "Archive" ];
      };
      
      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
        patterns = [ "*" "!Spam" ];
      };
      
      msmtp.enable = true;
      
      notmuch = {
        enable = true;
      };
    };
    
    "private" = {
      primary = false;
      address = readSecret config.age.secrets.email-private-address.path;
      userName = readSecret config.age.secrets.email-private-address.path;
      realName = readSecret config.age.secrets.email-private-realname.path;
      passwordCommand = "rbw get '${readSecret config.age.secrets.email-private-rbw-key.path}'";
      
      imap = {
        host = "imap.startmail.com";
        port = 993;
        tls.enable = true;
      };
      
      smtp = {
        host = "smtp.startmail.com";
        port = 465;
        tls = {
          enable = true;
          useStartTls = false;
        };
      };
      
      folders = {
        inbox = "INBOX";
        sent = "Sent";
        drafts = "Drafts";
        trash = "Trash";
        junk = "Junk";
      };
      
      neomutt = {
        enable = true;
        extraMailboxes = [ "Archive" ];
      };
      
      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
        patterns = [ "*" "!Spam" ];
      };
      
      msmtp.enable = true;
      
      notmuch = {
        enable = true;
      };
    };
  };

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

  # User-specific packages
  home.packages = with pkgs; [
    rbw
    opencode
  ];
}
