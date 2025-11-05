{
  programs.nixvim.plugins.autoclose = {
    enable = true;
    keys = {
      "'" = {
        disabled_filetypes = [ "markdown" ];
      };
    };
  };
}
