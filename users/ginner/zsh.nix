{ config, ... }:
{
  programs.zsh = {
    enable = true;
    # autosuggestions.enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    dotDir = ".config/zsh";
    syntaxHighlighting.enable = true;
    history = {
      ignoreDups = true;
      expireDuplicatesFirst = true;
      ignoreSpace = true;
      share = true;
      size = 10000;
      path = "${config.home.homeDirectory}/.local/share/zsh/history";
      };
    shellAliases = {
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
    initExtra = ''
      setopt histverify
      setopt correct
    '';
  };
}
