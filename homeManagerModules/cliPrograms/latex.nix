{ config, pkgs, lib, ... }:

let
  cfg = config.myHomeModules.cliPrograms.latex;
in
{
  options.myHomeModules.cliPrograms.latex = {
    enable = lib.mkEnableOption "LaTeX distribution and tools";

    enableFull = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable full texlive distribution (large download)";
    };

    scheme = lib.mkOption {
      type = lib.types.enum [ "small" "medium" "full" ];
      default = if cfg.enableFull then "full" else "medium";
      description = "LaTeX scheme to install";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = config.home.packages ++ (with pkgs; [
      (if cfg.scheme == "small" then texlive.combined.scheme-small
       else if cfg.scheme == "medium" then texlive.combined.scheme-medium
       else texlive.combined.scheme-full)
    ]);
  };
}
