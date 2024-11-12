{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    firefox.url = "github:nix-community/flake-firefox-nightly";
    firefox.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          hostParams = {
            username = "keganre";
            hostname = "desktop";
          };
        };
        modules = [
          ./hosts/desktop.nix
          ./hardware/desktop-hardware-configuration.nix
          ./hardware/desktop-boot.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              hostParams = {
                username = "keganre";
                hostname = "desktop";
              };
            };
          }
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          hostParams = {
            username = "keganre";
            hostname = "laptop";
          };
        };
        modules = [
          ./hosts/laptop.nix
          ./hardware/laptop-hardware-configuration.nix
          ./hardware/laptop-boot.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              hostParams = {
                username = "keganre";
                hostname = "laptop";
              };
            };
          }
        ];
      };
    };
  };
}
