{
  programs.nixvim.plugins.lualine = {
    enable = true;
    settings = {
      tabline = {
        lualine_a = [ "buffers" ];
      };
    };
  };
}
