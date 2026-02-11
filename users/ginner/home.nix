{ config, pkgs, inputs, lib, ... }:

let
  # Import email configuration from git-ignored file
  # Location: users/ginner/email-config.nix (in repo but git-ignored)
  # Template: users/ginner/email-config.template.nix
  #
  # IMPORTANT: After creating email-config.nix, run:
  #   git add -N users/ginner/email-config.nix
  # This makes the file visible to Nix without committing its content.
  emailConfig = import ./email-config.nix;
in
{
  # Enable email services (infrastructure only, accounts defined below)
  myHomeModules.services.email-accounts.enable = true;
  myHomeModules.tuiPrograms.neomutt.enable = true;
  myHomeModules.tuiPrograms.khard.enable = true;

  # Define email accounts from external configuration
  accounts.email.accounts = {
    "work" = {
      primary = true;
      address = emailConfig.work.address;
      userName = emailConfig.work.address;
      realName = emailConfig.work.realName;
      passwordCommand = emailConfig.work.passwordCommand;
      
      # IMAP settings for StartMail
      imap = {
        host = "imap.startmail.com";
        port = 993;
        tls = {
          enable = true;
          useStartTls = false;
        };
      };
      
      # SMTP settings for StartMail
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
      address = emailConfig.private.address;
      userName = emailConfig.private.address;
      realName = emailConfig.private.realName;
      passwordCommand = emailConfig.private.passwordCommand;
      
      # IMAP settings for StartMail
      imap = {
        host = "imap.startmail.com";
        port = 993;
        tls = {
          enable = true;
          useStartTls = false;
        };
      };
      
      # SMTP settings for StartMail
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
