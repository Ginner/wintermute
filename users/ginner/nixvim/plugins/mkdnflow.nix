{
  programs.nixvim.plugins.mkdnflow = {
    enable = true;
    wrap = true;
    silent = true;
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
}
