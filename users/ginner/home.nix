{ config, pkgs, inputs, ... }:

{
  imports = [
    ./waybar.nix
    ./hyprland.nix
    ./firefox.nix
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
    bc
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

  # programs.yazi = {
  #   enable = true;
  # };
  programs.yazi = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Ginner";
    userEmail = "26798615+Ginner@users.noreply.github.com";
  };


  home.pointerCursor = {
    gtk.enable = true;
    name = "rose-pine-hyprcursor";
    package = inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default;
    size = 16; # Adjust as needed
  };
  gtk.enable = true;

  # home.pointerCursor = {
  #   gtk.enable = true;
  #   # x11.enable = true;
  #   package = pkgs.rose-pine-hyprcursor;
  #   name = "rose-pine-hyprcursor";
  #   size = 16;
  # };

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

  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      color_theme = "gruvbox_dark_v2";
    };
  };

  programs.zsh = {
    enable = true;
    # autosuggestions.enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    syntaxHighlighting.enable = true;
    history = {
      ignoreDups = true;
      expireDuplicatesFirst = true;
      ignoreSpace = true;
      share = true;
      size = 10000;
      path = "${config.home.homeDirectory}/.local/share/zsh/history";
      };
    shellAliases = {
      history = "history 1";
      ls = "eza";
      ll = "eza -l";
      lt = "eza -T";
      la = "eza -lah --group-directories-first";
      las = "eza -lah --group-directories-first --total-size";
      cal = "cal -wm";
      cp = "cp -riv";
      mv = "mv -iv";
      rm = "rm -I";
      mkdir = "mkdir -vp";
    };
  };

  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
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


  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    download = "${config.home.homeDirectory}/INBOX";
    music = "${config.home.homeDirectory}/MEDIA/Music";
    videos = "${config.home.homeDirectory}/MEDIA/Videos";
    pictures = "${config.home.homeDirectory}/MEDIA/Pictures";
    desktop = null;
    documents = null;
    publicShare = null;
    templates = null;
  };

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "text/plain" = [ "neovide.desktop" ];
    "application/pdf" = [ "zathura.desktop" ];
    "image/*" = [ "sxiv.desktop" ];
    "video/png" = [ "mpv.desktop" ];
    "video/jpg" = [ "mpv.desktop" ];
    "video/*" = [ "mpv.desktop" ];
  };

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
    # GTK_CURSOR_THEME = "rose-pine-hyprcursor";
    # GTK_CURSOR_SIZE = "24"; # Must be a string
    # XCURSOR_THEME = "rose-pine-hyprcursor";
    # XCURSOR_SIZE = "24";
  };

  home.stateVersion = "22.11"; # Please read the manual before changing.
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
