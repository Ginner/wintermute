{
  programs.nixvim.plugins.autoclose = {
    enable = true;
    settings = {
      keys = {
        "'" = {
          disabled_filetypes = [ "markdown" "latex" ];
        };
      };
    };
  };
}
