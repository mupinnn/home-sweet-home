{
  description =
    "mupin's multi-machine system configuration with Nix and `home-manager` using Flakes";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixvim, ... }@inputs:
    let
      hosts = import ./config/hosts.nix;
    in {
      nixosConfigurations = {
        "${hosts.nixProvidence.hostname}" = nixpkgs.lib.nixosSystem {
          system = hosts.nixProvidence.arch;
          specialArgs = {
            inherit inputs;
            host = hosts.nixProvidence;
          };
          modules = [
            ./hosts/${hosts.nixProvidence.dir}/default.nix
            
            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users."${hosts.nixProvidence.user}" = import ./hosts/${hosts.nixProvidence.dir}/home.nix {
                pkgs = nixpkgs.legacyPackages."${hosts.nixProvidence.arch}";
                host = hosts.nixProvidence;
              };
            }
          ];
        };
      };
    };
}
