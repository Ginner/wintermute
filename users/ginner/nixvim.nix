{ config, pkgs, inputs, ... }:

{
  programs.nixvim = {
    enable = true;

    colorschemes.gruvbox.enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    globals.mapleader = " ";
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };
    opts = {
      # Editor
      relativenumber = true;
      number = true;
      # numberwidth = 4;   # Doesn't seem to have any effect...
      signcolumn = "yes";# Preserve that precious screen real-estate
      cursorline = true;
      scrolloff = 5;
      showcmd = true;
      cmdheight = 0;

      # Tab & indentation
      shiftwidth = 2;
      softtabstop = 2;
      expandtab = true;
      autoindent = true;
      smartindent = true;
      smarttab = true;

      # Macros
      lazyredraw = true;

      # Syntax
      showmatch = true;

      # Files
      filetype = "on";

    };
    autoCmd = [
      {
        command = "setlocal autowriteall";
        event = [ "FileType" "BufRead" ];
        pattern = [ "markdown" "*.md" "*.markdown" ];
      }
      {
        command = "silent! wall";
        event = [ "BufLeave" ];
        pattern = [ "markdown" "*.md" "*.markdown" ];
      }
      {
        command = "norm zz";
        event = [ "InsertEnter" ];
        pattern = [ "*" ];
      }{
        command = "%s/\s\+$//e";
        event = [ "BufWritePre" ];
        pattern = [ "*" ];
      }
    ];
    keymaps = [
      {
        action = "<cmd>Telescope live_grep<CR>";
	key = "<leader>g";
      }
      {
        action = "<cmd>bnext<CR>";
        key = "gb";
        mode = "n";
      }
      {
        action = "<cmd>bprevious<CR>";
        key = "gB";
        mode = "n";
      }
      {
        action = "nzzzv";
        key = "n";
        mode = "n";
      }
      {
        action = "Nzzzv";
        key = "N";
        mode = "n";
      }
      {
        action = ",<c-g>u";
        key = ",";
        mode = "i";
      }
      {
        action = ".<c-g>u";
        key = ".";
        mode = "i";
      }
      {
        action = "!<c-g>u";
        key = "!";
        mode = "i";
      }
      {
        action = "?<c-g>u";
        key = "?";
        mode = "i";
      }

    ];
    plugins.lualine = {
      enable = true;
      settings = {
        tabline = {
          lualine_a = [ "buffers" ];
        };
      };
    };
    plugins.lsp = {
      enable = true;
      servers = {
        nixd.enable = true;
	marksman.enable = true;
      };
    };
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        sources = [
          { name = "nvim_lsp"; }
	  { name = "path"; }
	  { name = "buffer"; }
        ];
	mapping = {
	  "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
	  "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
	  "<CR>" = "cmp.mapping.confirm({ select = false })";
	  "<C-e>" = "cmp.mapping.close()";
	};
      };
    };
    plugins.telescope.enable = true;
    plugins.treesitter = {
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
          disable = [ "markdown" ];
        };
        indent.enable = true;
        autopairs.enable = true;
      };
    };
    plugins.mkdnflow = {
      enable = true;
      wrap = true;
      links.conceal = true;
      modules = {
        bib = false;
      };
      perspective = {
        rootTell = "index.md";
        priority = "root";
      };
      mappings = {
        MkdnEnter = {
          key = "<CR>";
          modes = [
            "i"
            "n"
            "v"
          ];
        };
      };
    };
  };
}
