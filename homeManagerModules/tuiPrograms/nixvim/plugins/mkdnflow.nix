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
      to_do.symbols = [
        " "
        "/"
        "x"
      ];
      mappings = {
        MkdnCreateLink = [ [ "n" ] "<leader>ln" ];
        MkdnEnter = [ [ "i" "n" "v" ] "<cr>" ];
        MkdnToggleToDo = [ ["n" "i"] "<c-space>" ];
        };
      };
    };
}
