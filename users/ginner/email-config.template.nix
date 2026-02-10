# Email account configuration template
# 
# LOCATION: This file should be placed at:
#   ~/.config/nixos-secrets/email-config.nix
# 
# SETUP INSTRUCTIONS:
#   1. Create the directory and copy this template:
#      mkdir -p ~/.config/nixos-secrets
#      cp users/ginner/email-config.template.nix ~/.config/nixos-secrets/email-config.nix
#   
#   2. Edit with your real values:
#      $EDITOR ~/.config/nixos-secrets/email-config.nix
#   
#   3. Rebuild your system:
#      sudo nixos-rebuild switch --flake .#BISHOP
#
# This file is NEVER in git and contains your actual email addresses.
# The file location is outside the NixOS config repo to avoid any git tracking.
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
