{ pkgs, ... }:

let
  mkNodeJsShell = name:
    let node = pkgs.${name};
    in pkgs.mkShell {
      description =
        "Node.js v${pkgs.lib.strings.getVersion node} development environment";
      buildInputs = [ node pkgs.pnpm_10 pkgs.bun ];
    };

  nodeJsShells = builtins.listToAttrs (map (nodeJsPkg: {
    name = nodeJsPkg;
    value = mkNodeJsShell nodeJsPkg;
  }) [ "nodejs_20" "nodejs_22" "nodejs_24" ]);

in {
  ccpp = pkgs.mkShell {
    description = "C/C++ development environment";
    buildInputs = with pkgs; [ gcc13 clang clang-tools cmake gnumake ];
  };
} // nodeJsShells
