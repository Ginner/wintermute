{ config, lib, ... }:

{
  config = lib.mkIf config.myHomeModules.tuiPrograms.nixvim.enable {
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
          lualine_z = [ "tabs" ];
        };
      };
    };
  };
}
