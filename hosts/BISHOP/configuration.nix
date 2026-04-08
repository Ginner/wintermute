{ config, pkgs, inputs, ... }:
# let
#   home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
# in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.xremap-flake.nixosModules.default
      ../../nixosModules
      ../../users/ginner  # User-specific NixOS config
    ];

  # Use the systemd-boot EFI boot loader.


  networking.hostName = "BISHOP"; # Define your hostname.

  userGlobals = {
    username = "ginner";
  };

  myModules.laptop.enable = true; # Enable laptop module

  ## Below has to be handled during the restructure

  home-manager = {
    extraSpecialArgs = { inherit inputs; username = config.userGlobals.username; };
    users = {
      ${config.userGlobals.username} = import ./home.nix;
    };
  };

  myModules.shared.stylix = {
    enable = true;
    image = ../../assets/wall.jpeg;
  };

  myModules.services.tailscale.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    home-manager
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

  # boot.kernelParams = [ 
  #   "usbcore.autosuspend=-1"
  #   "usbcore.use_both_schemes=1"
  # ];
  #
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
      };
    };
  };
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  services.fwupd = {
    enable = true;
  };

  services.kmscon = {
    enable = true;
  };
  services.hardware.bolt.enable = true;

  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     USB_AUTOSUSPEND = 0;
  #
  #   # Remove the Dell dock blacklist since you're using a ThinkPad dock now
  #   # USB_DENYLIST = "";  # or comment out entirely
  #
  #   # Keep xhci_hcd out of runtime PM denylist (this looks good)
  #     RUNTIME_PM_DRIVER_DENYLIST = "mei_me nouveau radeon";
  #
  #   # These settings look good as they are
  #     RUNTIME_PM_ON_AC = "on";
  #     RUNTIME_PM_ON_BAT = "auto";
  #     START_CHARGE_THRESH_BAT0=75;
  #     STOP_CHARGE_THRESH_BAT0=80;
  #   };
  # };

  # services.interception-tools = {
  #   enable = true;
  #   plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
  #   udevmonConfig = ''
  #   - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c /etc/dual-function-keys.yaml | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
  #     DEVICE:
  #       EVENTS:
  #         EV_KEY: [KEY_CAPSLOCK,]
  #   '';
  # };
  # environment.etc."dual-function-keys.yaml".text = builtins.readFile ./dual-function-keys.yaml;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}

