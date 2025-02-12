{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./zsh.nix
    ./kitty.nix
    ./xdg.nix
    # ./stylix.nix
    ./waybar.nix
    ./hyprland.nix
    ./firefox.nix
    ./ncspot.nix
    inputs.nixvim.homeManagerModules.nixvim
    ./nixvim/default.nix
  ];
  home.username = "ginner";
  home.homeDirectory = "/home/ginner";

  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    zathura
    newsboat
    numbat
    bat
    pass-wayland
    sxiv
    mpv
    calcurse
    khard
    imagemagick
    brightnessctl
    jq
    eza
    tree
    wget
    btop
    unzip
    cheat
    ffmpegthumbnailer
    p7zip
    zip
    xz
    unzip
    poppler
    fd
    ripgrep
    fzf
    zoxide
    wl-clipboard
    grim
    slurp
    wf-recorder
    swappy
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  programs.zsh = {
    enable = true;
  };

  programs.yazi = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Ginner";
    userEmail = "26798615+Ginner@users.noreply.github.com";
  };
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };


  # I'll try setting it through stylix
  # home.pointerCursor = {
  #   gtk.enable = true;
  #   name = "rose-pine-hyprcursor";
  #   package = inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default;
  #   # size = 16; # Adjust as needed
  # };
  # gtk.enable = true;

  # home.pointerCursor = {
  #   gtk.enable = true;
  #   # x11.enable = true;
  #   package = pkgs.rose-pine-hyprcursor;
  #   name = "rose-pine-hyprcursor";
  #   size = 16;
  # };

  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      # color_theme = "gruvbox_dark_v2";
    };
  };

  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  stylix.targets.waybar.enable = false;

  services.mako = {
    enable = true;
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ginner/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.stateVersion = "22.11"; # Please read the manual before changing.
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
