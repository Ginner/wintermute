{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ../../homeManagerModules
    inputs.nixvim.homeManagerModules.nixvim
    inputs.ags.homeManagerModules.default
    inputs.xremap-flake.homeManagerModules.default
    ../../users/ginner/nixvim/default.nix
    ../../users/ginner/scripts.nix
    ../../users/ginner/ags.nix
  ];
  # Enable laptop home configuration
  myHomeModules.laptop.enable = true;

  # Additional packages not covered by laptop bundle
  home.packages = with pkgs; [
    neomutt
    eza
    poppler
    zoxide
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

  # Override git configuration with proper values
  myHomeModules.cliPrograms.git = {
    userName = "Ginner";
    userEmail = "26798615+Ginner@users.noreply.github.com";
  };

  # Override SSH configuration
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/id_ed25519_sk";
      };
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

  # programs.starship = {
  #   enable = true;
  #   # custom settings
  #   settings = {
  #     add_newline = false;
  #     aws.disabled = true;
  #     gcloud.disabled = true;
  #     line_break.disabled = true;
  #   };
  # };

  # Stylix configuration is handled by laptop bundle

  #moved
  # services.xremap = {
  #   enable = true;
  #   withHypr = true;
  #    config = {
  #     modmap = [
  #       {
  #         name = "main-remaps";
  #         remap = {
  #           "CapsLock" = { held = "Super_L"; alone = "Esc"; alone_timeout_millis = 200; };
  #         };
  #       }
  #     ];
  #   };   
  # };
  #
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
  # Host-specific configuration
  home.stateVersion = "22.11"; # Set based on when this host was installed
}
