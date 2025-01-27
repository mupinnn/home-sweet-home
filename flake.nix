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
  };

  outputs = { nixpkgs, home-manager, nixvim, ... }: {
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;

    homeConfigurations = {
      mupin = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          # overlays = [
          #   (final: prev: {
          #     hello = final.writeShellScriptBin "hello" ''
          #       ${prev.hello}/bin/hello -g "hellorld" "$@"
          #     '';
          #   })
          #
          #   (import ./overlays/nvim-lspconfig.nix)
          # ];
        };
        modules = [ nixvim.homeManagerModules.nixvim ./home.nix ];
      };
    };
  };
}
