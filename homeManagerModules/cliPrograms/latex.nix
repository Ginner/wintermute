{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.myHomeModules.cliPrograms.latex;

  schemePackage =
    if cfg.scheme == "small" then
      pkgs.texliveSmall
    else if cfg.scheme == "medium" then
      pkgs.texliveMedium
    else
      pkgs.texliveFull;

  texlivePackage = schemePackage.withPackages (
    ps:
    (with ps; [
      latex-bin
      latexmk
      xetex
      collection-latexrecommended
      collection-fontsrecommended
    ])
    ++ cfg.extraPackages ps
  );
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
      type = lib.types.enum [
        "small"
        "medium"
        "full"
      ];
      default = if cfg.enableFull then "full" else "medium";
      description = "LaTeX scheme to install";
    };

    extraPackages = lib.mkOption {
      type = lib.types.functionTo (lib.types.listOf lib.types.package);
      default = _: [ ];
      description = "Additional TeX Live packages to include in the environment.";
      example = lib.literalExpression ''
        ps: with ps; [ wallpaper ]
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      texlivePackage
    ];
  };
}
