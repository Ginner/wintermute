{ pkgs, inputs, ... }:

{
  programs.ags = {
    enable = true;
    configDir = ./ags;
    extraPackages = with pkgs; [
      inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.battery
      fzf
    ];
  };
}
