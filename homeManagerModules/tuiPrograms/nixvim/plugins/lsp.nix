{ config, lib, ... }:

{
  config = lib.mkIf config.myHomeModules.tuiPrograms.nixvim.enable {
    programs.nixvim.plugins.lsp = {
      enable = true;
      servers = {
        nixd.enable = true;
        marksman.enable = true;
      };
    };
  };
}
