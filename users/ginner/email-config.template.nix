# Email account configuration template
# 
# LOCATION: This file should be copied to:
#   users/ginner/email-config.nix (in repo but git-ignored)
# 
# SETUP INSTRUCTIONS:
#   1. Copy this template:
#      cp users/ginner/email-config.template.nix users/ginner/email-config.nix
#   
#   2. Edit with your real values:
#      $EDITOR users/ginner/email-config.nix
#   
#   3. Make visible to Nix without committing content:
#      git add -N -f users/ginner/email-config.nix
#   
#   4. Rebuild your system:
#      sudo nixos-rebuild switch --flake .#BISHOP
#
# This file is git-ignored so your actual email addresses are never committed.
# The 'git add -N' command makes the file visible to Nix flake evaluation
# without staging its content for commit.
#
# Password command options:
# - rbw (Bitwarden): "rbw get 'Email - account@example.com'"
# - pass: "pass show email/account-name"
# - gpg: "gpg --decrypt ~/.password-store/work-email.gpg"
# - Any command that outputs the password to stdout
#
# Note: IMAP/SMTP server settings are configured in users/ginner/home.nix
# This file only contains email addresses, real names, and password commands.

{
  # Work email account
  work = {
    address = "@WORK_EMAIL_ADDRESS@";           # e.g., "you@company.com"
    realName = "@WORK_REAL_NAME@";              # e.g., "Your Full Name"
    passwordCommand = "@WORK_PASSWORD_COMMAND@"; # e.g., "rbw get 'Email - you@company.com'"
  };
  
  # Private email account
  private = {
    address = "@PRIVATE_EMAIL_ADDRESS@";         # e.g., "you@personal.com"
    realName = "@PRIVATE_REAL_NAME@";            # e.g., "Your Name"
    passwordCommand = "@PRIVATE_PASSWORD_COMMAND@"; # e.g., "pass show email/private"
  };
  
  # Future accounts can be added here:
  # gmail1 = {
  #   address = "...";
  #   realName = "...";
  #   passwordCommand = "...";
  # };
}
