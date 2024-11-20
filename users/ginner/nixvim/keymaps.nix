{
  programs.nixvim.keymaps = [
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
}
