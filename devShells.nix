{ pkgs, devenv, inputs, ... }:

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
} // nodeJsShells
