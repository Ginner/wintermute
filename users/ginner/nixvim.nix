{ config, pkgs, inputs, ... }:

{
  programs.nixvim = {
    enable = true;

    colorschemes.gruvbox.enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
