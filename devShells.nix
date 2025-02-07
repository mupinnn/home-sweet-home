{ pkgs, devenv, inputs, pgsqlServices, ... }:

let
  mkNodeJsShell = name:
    let node = pkgs.${name};
    in pkgs.mkShell {
      description =
        "Node.js v${pkgs.lib.strings.getVersion node} development environment";
      buildInputs = [ node pkgs.nodePackages.pnpm pkgs.bun ];
    };

  nodeJsShells = builtins.listToAttrs (map (nodeJsPkg: {
    name = nodeJsPkg;
    value = mkNodeJsShell nodeJsPkg;
  }) [ "nodejs_18" "nodejs_20" "nodejs_22" ]);

in {
  php83 = devenv.lib.mkShell {
    inherit inputs pkgs;

    modules = [{
      languages.php = {
        enable = true;
        package = pkgs.php83;
      };
    }];
  };

  ccpp = pkgs.mkShell {
    description = "C/C++ development environment";
    buildInputs = with pkgs; [ gcc13 clang clang-tools cmake gnumake ];
  };

  pgsql = pkgs.mkShell {
    inputsFrom = [ pgsqlServices.config.services.outputs.devShell ];
  };

  # pgsql = devenv.lib.mkShell {
  #   inherit inputs pkgs;
  #
  #   modules = [{
  #     env = {
  #       DBNAME = "our-db";
  #       DBUSER = builtins.getEnv "USER";
  #       HOSTNAME = "localhost";
  #       DBPORT = 5432;
  #     };
  #
  #     services.postgres = {
  #       enable = true;
  #       package = pkgs.postgresql_15;
  #       port = 5432;
  #       listen_addresses = "127.0.0.1";
  #       initialDatabases = [{ name = "our-db"; }];
  #     };
  #   }];
  # };
} // nodeJsShells
