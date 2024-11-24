{ config, pkgs, inputs, ... }:

{
  imports = [
    ./options.nix
    ./autocommands.nix
    ./keymaps.nix
    ./plugins/lualine.nix
    ./plugins/lsp.nix
    ./plugins/cmp.nix
    ./plugins/treesitter.nix 
    ./plugins/mkdnflow.nix
  ];

  programs.nixvim = {
    enable = true;

    # colorschemes.gruvbox.enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    globals.mapleader = " ";
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };
    plugins = {
      telescope.enable = true;
      web-devicons.enable = true;
      vim-surround.enable = true;
      lastplace.enable = true;
    };
  };
}
