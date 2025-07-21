{ pkgs, inputs, ... }:

{
  programs.ags = {
    enable = true;
    configDir = ./ags;
    extraPackages = with pkgs; [
      inputs.ags.packages.${pkgs.system}.battery
      fzf
    ];
  };
}
