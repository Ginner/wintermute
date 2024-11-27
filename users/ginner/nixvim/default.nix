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
    extraConfigLua = ''
      vim.treesitter.query.set(
        'markdown',
        'highlights',
        [[
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
          ((task_list_marker_checked) @conceal (#set! conceal "󰄵"))
          ((task_list_marker_unchecked) @conceal (#set! conceal "󰄱"))
          ;(paragraph
          ;  (inline
          ;    (shortcut_link
          ;      (link_text))) @_checkmark (#lua-match? @_checkmark "\[-\]")(#set! conceal "󰄗"))
        ]]
      )
    '';
  };
}
          # ([
          #   (info_string)
          #   (fenced_code_block_delimiter)
          # ] @conceal 
          #   (#set! conceal "")
          #   )
# ((task_list_marker_checked) @text.todo.checked (#offset! @text.todo.checked 0 -2 0 0)(#set! conceal ""))
