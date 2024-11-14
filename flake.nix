{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    firefox.url = "github:nix-community/flake-firefox-nightly";
    firefox.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, firefox, ... }@inputs: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;  # Pass all inputs to specialArgs
          hostParams = {
            username = "keganre";
            hostname = "desktop";
            inputs = inputs; # Ensure inputs are accessible in hostParams
          };
        };
        modules = [
          ./hosts/desktop/sys/configuration.nix
          ./hosts/desktop/usr/home.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              hostParams = {
                username = "keganre";
                hostname = "desktop";
                inputs = inputs; # Ensure inputs are accessible here as well
              };
            };
          }
        ];
      };
    };
  };
}
