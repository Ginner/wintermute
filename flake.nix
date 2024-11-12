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
    # yazi = {
    #   url = "github:sxyazi/yazi";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, ... } @ inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    nixosConfigurations = {
      WINTERMUTE = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system ; };
        modules = [
          ./hosts/WINTERMUTE/configuration.nix
	  inputs.home-manager.nixosModules.default
	];
      };
      UMMON = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/UMMON/configuration.nix
	];
      };
    };
  };
}
