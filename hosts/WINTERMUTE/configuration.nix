# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

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

  networking.hostName = "WINTERMUTE"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "da_DK.UTF-8";
  i18n.extraLocaleSettings = {
    LANG = "en_DK.UTF-8";
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dk";
    # useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    };
  # hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable home-manager
  # home-manager.useGlobalPkgs = true;
  # home-manager.useUserPackages = true;


  users.defaultUserShell = pkgs.zsh;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ginner = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
  };
  
  home-manager = {
    extraSpecialArgs = { inherit inputs ; };
    users = {
      "ginner" = import ../../users/ginner/home.nix;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.zsh = {
    enable = true;
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
    libnotify
    gawk
    rofi-wayland
    # ly # Maybe swap it for lemurs when available, ly is old in main but not in unstable - Use greetd for now
    upower
    tlp
    rsync
    wl-clipboard
    killall
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
  ];

  fonts.packages = with pkgs; [
    # (nerdfonts.override { fonts = [ "Hack Nerd Font" "FiraCode"]; })
    nerdfonts
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
  services.netbird.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland";
      };
    };
  };

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0=75;
      STOP_CHARGE_THRESH_BAT0=80;
    };
  };

  services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
    udevmonConfig = ''
    - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c /etc/dual-function-keys.yaml | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
      DEVICE:
        EVENTS:
          EV_KEY: [KEY_CAPSLOCK,]
    '';
  };
  environment.etc."dual-function-keys.yaml".text = builtins.readFile ./dual-function-keys.yaml;

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
  system.stateVersion = "23.05"; # Did you read the comment?

}

