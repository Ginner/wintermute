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
      to_do = {
        statuses = {
          not_started = {
            marker = " ";
            sort = { section = 2; position = "top"; };
          };
          in_progress = {
            marker = "/";
            sort = { section = 1; position = "bottom"; };
          };
          complete = {
            marker = [ "X" "x" ];
            sort = { section = 1; position = "bottom"; };
          };
        };
      };
      mappings = {
        MkdnCreateLink = [ [ "n" ] "<leader>ln" ];
        MkdnEnter = [ [ "i" "n" "v" ] "<cr>" ];
        MkdnToggleToDo = [ ["n" "i"] "<c-space>" ];
      };
    };
  };
}
