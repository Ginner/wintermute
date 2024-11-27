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
      autoclose.enable = true;
    };
  };
  home.file = {
    ".config/nvim/after/queries/markdown/highlights.scm".text = ''
      ;; extends
      (list_item [
        (list_marker_plus)
        (list_marker_minus)
        (list_marker_star)
        (list_marker_dot)
        (list_marker_parenthesis)
      ] @conceal [
        (task_list_marker_checked)
        (task_list_marker_unchecked)
      ](#set! conceal ""))
      ((task_list_marker_checked) @my_checked (#set! conceal "󰄵"))
      ((task_list_marker_unchecked) @my_unchecked (#set! conceal "󰄱"))
    '';
    ".config/nvim/after/queries/markdown_inline/highlights.scm".text = ''
      ;; extends
      (shortcut_link (link_text) @my_partial (#lua-match? @my_partial "^/$") (#offset! @my_partial 0 -3 0 0)(#set! conceal "󱗝"))
      (shortcut_link (link_text) @my_wont_do (#lua-match? @my_wont_do "^-$") (#offset! @my_wont_do 0 -3 0 0)(#set! conceal "󰅘"))
    '';
  };
}
