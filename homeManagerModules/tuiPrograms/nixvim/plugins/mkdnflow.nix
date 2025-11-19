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
        MkdnCreateLink = {
          key = "<leader>ln";
          modes = [
            "n"
          ];
        };
        MkdnEnter = {
          key = "<CR>";
          modes = [
            "i"
            "n"
            "v"
          ];
        };
      };
      to_do.symbols = [
        " "
        "/"
        "x"
      ];
    };
  };
}
