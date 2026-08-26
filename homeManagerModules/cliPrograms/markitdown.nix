{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.myHomeModules.cliPrograms.markitdown;
in
{
  options.myHomeModules.cliPrograms.markitdown.enable =
    lib.mkEnableOption "MarkItDown document-to-Markdown converter";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.markitdown ];
  };
}
