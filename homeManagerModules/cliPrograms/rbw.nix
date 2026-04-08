{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules.cliPrograms.rbw;
in
{
  options.myHomeModules.cliPrograms.rbw = {
    enable = lib.mkEnableOption "rbw (Rust Bitwarden client)";

    pinentry = lib.mkOption {
      type = lib.types.str;
      default = "pinentry-tty";
      description = "Pinentry binary to use for rbw";
    };

    lockTimeout = lib.mkOption {
      type = lib.types.int;
      default = 3600;
      description = "Vault lock timeout in seconds";
    };

    emailSecret = lib.mkOption {
      type = lib.types.path;
      description = "Path to sops-decrypted file containing the Bitwarden email";
    };

    baseUrlSecret = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to sops-decrypted file containing the Bitwarden base URL (for self-hosted)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.rbw ];

    home.activation.rbwConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.config/rbw"
      email=$(cat "${cfg.emailSecret}")
      json="{\"email\": \"$email\", \"lock_timeout\": ${toString cfg.lockTimeout}, \"pinentry\": \"${cfg.pinentry}\""
      ${lib.optionalString (cfg.baseUrlSecret != null) ''
        base_url=$(cat "${cfg.baseUrlSecret}")
        json="$json, \"base_url\": \"$base_url\""
      ''}
      json="$json}"
      printf '%s\n' "$json" > "$HOME/.config/rbw/config.json"
    '';
  };
}
