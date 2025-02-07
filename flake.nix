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

  outputs = { self, home-manager, nixvim, devenv, ... }@inputs:
    let
      inherit (self) outputs;

      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};

      pgsqlServices = (import inputs.process-compose-flake.lib {
        inherit pkgs;
      }).evalModules {
        modules = [
          inputs.services-flake.processComposeModules.default
          { services.postgres."pg1".enable = true; }
        ];
      };
    in {
      homeConfigurations = {
        mupin = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [ nixvim.homeManagerModules.nixvim ./home.nix ];
          extraSpecialArgs = { inherit inputs outputs; };
        };
      };

      # There is an active issue regarding `devenv up` command for multiple shells setup
      # @see https://github.com/cachix/devenv/issues/1178
      # packages.${system} = {
      #   pgsql-devenv-up = self.devShells.${system}.pgsql.config.procfileScript;
      # };

      packages.${system} = { pgsql = pgsqlServices.config.outputs.package; };

      devShells.${system} = import ./devShells.nix {
        inherit pkgs devenv inputs outputs pgsqlServices;
      };
    };
}
