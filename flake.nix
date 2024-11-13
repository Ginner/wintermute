{
  description = "System configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi = {
      url = "github:sxyazi/yazi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, yazi, ... } @ inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ yazi.overlays.default ];
    };
  in
  {
    nixosConfigurations = {
      WINTERMUTE = nixpkgs.lib.nixosSystem {
      	inherit system;
        specialArgs = { inherit inputs pkgs ; };
        modules = [
          ./hosts/WINTERMUTE/configuration.nix
	  inputs.home-manager.nixosModules.default
	];
      };
      UMMON = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs pkgs; };
        modules = [
          ./hosts/UMMON/configuration.nix
	];
      };
    };
  };
}
