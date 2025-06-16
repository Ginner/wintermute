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

  networking.hostName = "BISHOP"; # Define your hostname.

  myModules.laptop.enable = true; # Enable laptop module

  userGlobals = {
    username = "ginner";
  };


  ## Below has to be handled during the restructure

  home-manager = {
    extraSpecialArgs = { inherit inputs ; };
    users = {
      "ginner" = import ../../users/ginner/home.nix;
    };
  };

  myModules.shared.stylix = {
    enable = true;
    image = ./wall.jpeg;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    home-manager
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
  ];

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

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

