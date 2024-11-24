{
  programs.nixvim.plugins.lualine = {
    enable = true;
    settings = {
      tabline = {
        lualine_a = [ 
          {
            __unkeyed-1 = "buffers";
            symbols.alternate_file = "";
          }
        ];
          # {
          #   name = "buffers";
          #   symbols = {
          #     modified = "•";
          #     alternate_file = "";
          #   };
          #   buffers_color = {
          #     active = "lualine_{section}_normal";
          #     inactive = "lualine_{section}_inactive";
          #   };
          #   mode = 1;
          # }
        lualine_z = [ "tabs" ];
      };
    };
  };
}
