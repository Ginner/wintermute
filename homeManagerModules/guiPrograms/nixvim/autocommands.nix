{
  programs.nixvim.autoGroups = {
    mymdgrp.clear = true;
    wikigrp.clear = true;
  };
  programs.nixvim.autoCmd = [
    {
      command = "setlocal autowriteall";
      event = [ "FileType" "BufRead" ];
      pattern = [ "markdown" "*.md" "*.markdown" ];
      group = "mymdgrp";
    }
    {
      desc = "Save the buffer when leaving (e.g. following links in wiki)";
      command = "silent! wall";
      event = [ "BufLeave" ];
      pattern = [ "markdown" "*.md" "*.markdown" ];
      group = "mymdgrp";
    }
    {
      desc = "Vertically center the buffer when entering insert mode";
      command = "norm zz";
      event = [ "InsertEnter" ];
      pattern = [ "*" ];
    }{
      desc = "Remove trailing whitespace before writing files";
      command = "%s/\s\+$//e";
      event = [ "BufWritePre" ];
      pattern = [ "*" ];
    }
  ];
}
