{
  programs.nixvim.autoCmd = [
    {
      command = "setlocal autowriteall";
      event = [ "FileType" "BufRead" ];
      pattern = [ "markdown" "*.md" "*.markdown" ];
    }
    {
      command = "silent! wall";
      event = [ "BufLeave" ];
      pattern = [ "markdown" "*.md" "*.markdown" ];
    }
    {
      command = "norm zz";
      event = [ "InsertEnter" ];
      pattern = [ "*" ];
    }{
      command = "%s/\s\+$//e";
      event = [ "BufWritePre" ];
      pattern = [ "*" ];
    }
  ];
}
