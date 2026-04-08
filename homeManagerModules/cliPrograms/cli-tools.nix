{ config, pkgs, lib, ... }:

let
  cfg = config.myHomeModules.cliPrograms.cli-tools;
in
{
  options.myHomeModules.cliPrograms.cli-tools = {
    enable = lib.mkEnableOption "Essential CLI tools collection";

    enableAll = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable all CLI tools";
    };

    # Individual tool options
    bat.enable = lib.mkEnableOption "Modern cat replacement" // { default = cfg.enableAll; };
    eza.enable = lib.mkEnableOption "Modern ls replacement" // { default = cfg.enableAll; };
    fd.enable = lib.mkEnableOption "Modern find replacement" // { default = cfg.enableAll; };
    ripgrep.enable = lib.mkEnableOption "Modern grep replacement" // { default = cfg.enableAll; };
    fzf.enable = lib.mkEnableOption "Fuzzy finder" // { default = cfg.enableAll; };
    jq.enable = lib.mkEnableOption "JSON processor" // { default = cfg.enableAll; };
    wget.enable = lib.mkEnableOption "Web downloader" // { default = cfg.enableAll; };
    tree.enable = lib.mkEnableOption "Directory tree viewer" // { default = cfg.enableAll; };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      lib.optionals cfg.bat.enable [ bat ] ++
      lib.optionals cfg.eza.enable [ eza ] ++
      lib.optionals cfg.fd.enable [ fd ] ++
      lib.optionals cfg.ripgrep.enable [ ripgrep ] ++
      lib.optionals cfg.fzf.enable [ fzf ] ++
      lib.optionals cfg.jq.enable [ jq ] ++
      lib.optionals cfg.wget.enable [ wget ] ++
      lib.optionals cfg.tree.enable [ tree ];

    # Configure fzf integration
    programs.fzf = lib.mkIf cfg.fzf.enable {
      enable = true;
      enableZshIntegration = true;
    };

    # Configure bat
    programs.bat = lib.mkIf cfg.bat.enable {
      enable = true;
    };
  };
}