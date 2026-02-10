{ config, pkgs, inputs, lib, ... }:

let
  # Import email configuration from external file (outside git repo)
  # Location: ~/.config/nixos-secrets/email-config.nix
  # Template: users/ginner/email-config.template.nix
  emailConfigPath = "${config.home.homeDirectory}/.config/nixos-secrets/email-config.nix";
  
  # Provide placeholder values if external config doesn't exist (with warning)
  emailConfig = 
    if builtins.pathExists emailConfigPath
    then import emailConfigPath
    else (
      builtins.trace ''
        WARNING: Email configuration not found at ${emailConfigPath}
        
        Using placeholder values. To set up your email accounts:
          1. mkdir -p ~/.config/nixos-secrets
          2. cp users/ginner/email-config.template.nix ~/.config/nixos-secrets/email-config.nix
          3. Edit ~/.config/nixos-secrets/email-config.nix with your real values
          4. Rebuild: sudo nixos-rebuild switch --flake .#BISHOP
      ''
      {
        work = {
          address = "placeholder-work@example.com";
          realName = "Work Account Placeholder";
          passwordCommand = "echo 'PLACEHOLDER_PASSWORD'";
        };
        private = {
          address = "placeholder-private@example.com";
          realName = "Private Account Placeholder";
          passwordCommand = "echo 'PLACEHOLDER_PASSWORD'";
        };
      }
    );
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
