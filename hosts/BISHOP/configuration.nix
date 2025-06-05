
{ config, pkgs, inputs, ... }:
# let
#   home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
# in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      # (import "${home-manager}/nixos")
      # ./home/home.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "BISHOP"; # Define your hostname.

  myModules.laptop.enable = true; # Enable laptop module

  userGlobals = {
    username = "ginner";
  };


  ## Below has to be handled during the restructure

  # For xremap under home-manager
  users.groups.uinput.members = [ "ginner" ];
  users.groups.input.members = [ "ginner" ];

  home-manager = {
    extraSpecialArgs = { inherit inputs ; };
    users = {
      "ginner" = import ../../users/ginner/home.nix;
    };
  };

  stylix = {
    enable = true;
    image = ./wall.jpeg;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/google-dark.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/codeschool.yaml";
    cursor = {
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
      size = 16;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font Mono";
      };
      sizes = {
        terminal = 11;
        desktop = 11;
        applications = 11;
        popups = 14;
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    home-manager
    kitty
    mako
    waybar
    file
    # eww-wayland
    # libnotify _duplicate functionality with mako_
    gawk
    # ly # Maybe swap it for lemurs when available, ly is old in main but not in unstable - Use greetd for now
    rsync
    wl-clipboard
    killall
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    nixd
  ];

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  fonts.packages = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.fira-code
    ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  system.stateVersion = "24.11"; # Don't change this value unless you know what you are doing.

}

