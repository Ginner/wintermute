{ pkgs, ... }:

{
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
        # disable = [ "markdown" ];
      };
      indent.enable = true;
      autopairs.enable = true;
    };
    nixvimInjections = true;
  };
}
