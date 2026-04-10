{ config, pkgs, lib, ... }:

{
  # Email toolchain — account definitions drive all config file generation.
  # Sops secret key names default to "<accountname>-address" etc.; override only
  # if your secrets/email.yaml uses different key names.
  # The sops YAML file contains: work-address, work-realname, work-rbw-key,
  #                               private-address, private-realname, private-rbw-key
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/email.yaml;
  };

  myHomeModules.services.email = {
    enable = true;
    accounts = {
      work = {
        primary     = true;
        imapHost    = "imap.startmail.com";
        smtpHost    = "smtp.startmail.com";
        macroKey    = "1";
      };
      private = {
        primary     = false;
        imapHost    = "imap.startmail.com";
        smtpHost    = "smtp.startmail.com";
        macroKey    = "2";
      };
    };
  };

  myHomeModules.tuiPrograms.neomutt.enable = true;
  myHomeModules.tuiPrograms.khard.enable = true;

  # Git identity
  programs.git.settings.user = {
    name  = "Ginner";
    email = "26798615+Ginner@users.noreply.github.com";
  };

  # SSH match blocks
  myHomeModules.cliPrograms.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        user           = "git";
        identityFile   = "~/.ssh/id_ed25519_sk";
      };
      "forgejo" = {
        hostname       = "forgejo.ginnerskov.co";
        user           = "git";
        port           = 222;
        identityFile   = "~/.ssh/id_ed25519_sk";
      };
      "codeberg" = {
        user           = "git";
        hostname       = "codeberg.org";
        identityFile   = "~/.ssh/id_ed25519_sk";
      };
    };
  };

  myHomeModules.tuiPrograms.opencode.enable = true;

  home.packages = with pkgs; [
    rbw
  ];
}
