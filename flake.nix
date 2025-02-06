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
    process-compose-flake = {
      url = "github:Platonic-Systems/process-compose-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    services-flake = {
      url = "github:juspay/services-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, home-manager, nixvim, devenv, ... }@inputs:
    let
      inherit (self) outputs;

      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations = {
        mupin = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [ nixvim.homeManagerModules.nixvim ./home.nix ];
          extraSpecialArgs = { inherit inputs outputs; };
        };
      };

      # packages.${system} = {
      #   pgsql-devenv-up = self.devShells.${system}.pgsql.config.procfileScript;
      # };

      devShells.${system} =
        import ./devShells.nix { inherit pkgs devenv inputs outputs; };
    };
}
