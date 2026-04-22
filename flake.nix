{
  description =
    "mupin's multi-machine system configuration with Nix and Home Manager using Flakes";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/release-25.11";
    nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, systems, ... }@inputs:
    let
      inherit (self) outputs;

      lib = nixpkgs.lib // home-manager.lib;
      forEachSystem = f:
        lib.genAttrs (import systems) (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs (import systems) (system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        });
    in {
      inherit lib;

      nixosConfigurations = {
        nixProvidence = lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/nixProvidence/configuration.nix
            ./nixosModules
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.mupin = ./hosts/nixProvidence/home.nix;
            }
          ];
        };
      };

      homeConfigurations = {
        mupin = lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./homeManagerModules ];
          extraSpecialArgs = { inherit inputs; };
        };
      };

      devShells =
        forEachSystem (pkgs: import ./devShells.nix { inherit pkgs; });
    };
}
