{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ../../homeManagerModules
    inputs.nixvim.homeManagerModules.nixvim
    inputs.ags.homeManagerModules.default
  ];
  # Enable laptop home configuration
  myHomeModules.laptop.enable = true;

  # Override stylix wallpaper for BISHOP
  myHomeModules.guiPrograms.stylix.image = ../../assets/wall.jpeg;

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

  # Override SSH configuration with host-specific settings
  myHomeModules.cliPrograms.ssh.extraConfig = ''
    Host github.com
      User git
      IdentityFile ~/.ssh/id_ed25519_sk
  '';

  # programs.rofi = {
  #   enable = true;
  #   package = pkgs.rofi-wayland;
  # };

  # Starship configuration is handled by the laptop module

  # xremap configuration moved to system-level modules
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
