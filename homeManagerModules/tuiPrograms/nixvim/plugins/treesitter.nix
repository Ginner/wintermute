{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.myHomeModules.tuiPrograms.nixvim.enable {
    programs.nixvim.plugins.treesitter = {
      enable = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        nix
        python
        html
        bash
        css
        javascript
        markdown
        json
      ];
      settings = {
        highlight = {
          enable = true;
        };
        indent.enable = true;
        autopairs.enable = true;
      };
    };
  };
}
