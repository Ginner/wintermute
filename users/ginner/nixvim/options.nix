{
  programs.nixvim.opts = {
    # Editor
    relativenumber = true;
    number = true;
    # numberwidth = 4;   # Doesn't seem to have any effect...
    signcolumn = "yes";# Preserve that precious screen real-estate
    cursorline = true;
    scrolloff = 5;
    showcmd = true;
    cmdheight = 0;

    # Tab & indentation
    shiftwidth = 2;
    softtabstop = 2;
    expandtab = true;
    autoindent = true;
    smartindent = true;
    smarttab = true;

    # Macros
    lazyredraw = true;

    # Syntax
    showmatch = true;

    # Files
    filetype = "on";

  };
}
