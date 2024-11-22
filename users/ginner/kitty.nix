{
  programs.kitty = {
    enable = true;
    font = {
      name = "Hack Nerd Font Mono";
      size = 11.0;
    };
    shellIntegration.enableZshIntegration = true;
    themeFile = "Monokai_Pro";
    extraConfig = "
      window_padding_width 10
      ";
  };

}
