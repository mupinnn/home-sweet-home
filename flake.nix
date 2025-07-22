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
  };

  outputs = { self, ... }@inputs:
    let
      hosts = import ./config/hosts.nix;

      mkHomeConfigurations =
        {
          host,
          nixpkgs,
          home-manager,
          modules ? []
        }: home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = host.arch;
            config = {
              allowUnfree = true;
            };
          };
          modules = [
            ./hosts/${host.dir}/home.nix
          ] ++ modules;
        };

      mkNixOSConfigurations =
        {
          host,
          nixpkgs,
          home-manager,
          modules ? []
        }: nixpkgs.lib.nixosSystem {
          system = host.arch;
          modules = [
            ./hosts/${host.dir}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${host.user}" = import ./hosts/${host.dir}/home.nix;
            }
          ] ++ modules;
        };
    in {
      nixosConfigurations."${hosts.nixosFull.hostname}" = mkNixOSConfigurations {
        host = hosts.nixosFull;
        nixpkgs = inputs.nixpkgs;
        home-manager = inputs.home-manager;
      };

      homeConfigurations."${hosts.wsl.hostname}" = mkHomeConfigurations {
        host = hosts.wsl;
        nixpkgs = inputs.nixpkgs;
        home-manager = inputs.home-manager;
      };
    };
}
