{
  programs.nixvim.plugins.mkdnflow = {
    enable = true;
    settings = {
      wrap = true;
      silent = true;
      links.conceal = false;
      perspective = {
        root_tell = "wiki.md";
        priority = "current";
      };
      modules = {
        bib = false;
        conceal = false;
      };
      mappings = {
        MkdnCreateLink = "<leader>ln";
        MkdnEnter = "<CR>";
      };
      to_do.symbols = [
        " "
        "/"
        "x"
      ];
    };
  };
}
