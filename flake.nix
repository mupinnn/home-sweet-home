{
  description =
    "mupin's system configuration with Nix and `home-manager` using Flakes";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    services-flake.url = "github:juspay/services-flake";
  };

  outputs = { self, home-manager, nixvim, devenv, nixpkgs, process-compose-flake
    , services-flake, ... }@inputs:
    let
      inherit self;

      supportedSystems = [ "x86_64-linux" ];
    in {
      lib.forAllSystems = f:
        nixpkgs.lib.genAttrs supportedSystems (system:
          f rec {
            pkgs = nixpkgs.legacyPackages.${system};

            servicesModules = {
              pgsql = (import process-compose-flake.lib {
                inherit pkgs;
              }).evalModules {
                modules = [
                  services-flake.processComposeModules.default
                  { services.postgres."pg1".enable = true; }
                ];
              };
            };
          });

      homeConfigurations = {
        mupin = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${builtins.elemAt supportedSystems 0};
          modules = [ nixvim.homeManagerModules.nixvim ./home.nix ];
          extraSpecialArgs = { inherit self; };
        };
      };

      # There is an active issue regarding `devenv up` command for multiple shells setup
      # @see https://github.com/cachix/devenv/issues/1178
      # packages.${system} = {
      #   pgsql-devenv-up = self.devShells.${system}.pgsql.config.procfileScript;
      # };

      packages = self.lib.forAllSystems ({ servicesModules, ... }: {
        pgsql = servicesModules.pgsql.config.outputs.package;
      });

      devShells = self.lib.forAllSystems ({ servicesModules, pkgs, ... }:
        import ./devShells.nix { inherit pkgs devenv servicesModules inputs; });
    };
}
