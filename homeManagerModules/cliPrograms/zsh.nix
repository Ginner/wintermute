{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules.cli.zsh;
in
{
  options.myHomeModules.cli.zsh = {
    enable = lib.mkEnableOption "Zsh shell";

    enableAutosuggestions = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable zsh autosuggestions";
    };

    enableSyntaxHighlighting = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable zsh syntax highlighting";
    };

    enableCompletion = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable zsh completion";
    };

    enableAutocd = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable autocd in zsh";
    };

    dotDir = lib.mkOption {
      type = lib.types.str;
      default = ".config/zsh";
      description = "Directory for zsh configuration files";
    };

    extraInit = lib.mkOption {
      type = lib.types.lines;
      default = ''
        setopt histverify
        setopt correct
        eval "$(direnv hook zsh)"
      '';
      description = "Extra initialization commands for zsh";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableAutosuggestions = cfg.enableAutosuggestions;
      enableSyntaxHighlighting = cfg.enableSyntaxHighlighting;
      enableCompletion = cfg.enableCompletion;
      autocd = cfg.autocd;
      dotDir = "${config.home.homeDirectory}" + "/${cfg.dotDir}";
      history = {
        ignoreDups = lib.mkDefault true;
        expireDuplicatesFirst = lib.mkDefault true;
        ignoreSpace = lib.mkDefault true;
        share = lib.mkDefault true;
        size = lib.mkDefault 10000;
        path = "${config.home.homeDirectory}/.local/share/zsh/history";
      };
      shellAliases = lib.mkDefault {
        history = "history 1";
        ls = "eza";
        ll = "eza -l";
        lt = "eza -T";
        la = "eza -lah --group-directories-first";
        las = "eza -lah --group-directories-first --total-size";
        cal = "cal -wm";
        cp = "cp -riv";
        mv = "mv -iv";
        rm = "rm -I";
        mkdir = "mkdir -vp";
        ":q" = "exit";
      };
      initExtra = cfg.extraInit;
    };
    environment.systemPackages = with pkgs; [
      eza
    ];
  };
}
