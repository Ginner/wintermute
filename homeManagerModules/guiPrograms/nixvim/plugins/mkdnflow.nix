{
  programs.nixvim.plugins.mkdnflow = {
    enable = true;
    wrap = true;
    silent = true;
    links.conceal = false;
    modules = {
      bib = false;
      conceal = false;
    };
    perspective = {
      rootTell = "wiki.md";
      priority = "current";
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
    toDo.symbols = [
      " "
      "/"
      "x"
    ];
  };
}
