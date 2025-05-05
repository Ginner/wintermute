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
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi = {
      url = "github:sxyazi/yazi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap-flake = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    taskfinder = {
      url = "git+https://codeberg.org/ginner/taskfinder?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, yazi, ... } @ inputs:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations = {
      WINTERMUTE = nixpkgs.lib.nixosSystem {
      	inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/WINTERMUTE/configuration.nix
	  inputs.home-manager.nixosModules.default
          inputs.stylix.nixosModules.stylix
          {
              nixpkgs.overlays = [
                yazi.overlays.default
              ];
            }
	];
      };
      BISHOP = nixpkgs.lib.nixosSystem {
      	inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/BISHOP/configuration.nix
	  inputs.home-manager.nixosModules.default
          inputs.stylix.nixosModules.stylix
          {
              nixpkgs.overlays = [
                yazi.overlays.default
              ];
            }
	];
      };
      UMMON = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/UMMON/configuration.nix
            {
              nixpkgs.overlays = [
                yazi.overlays.default
              ];
            }
	];
      };
    };
  };
}
