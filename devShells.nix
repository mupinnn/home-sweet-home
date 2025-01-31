{ pkgs, ... }:

let
  inherit (pkgs) lib;

  # @see https://github.com/r17x/universe/blob/main/nix/overlays/default.nix#L26
  mutFirstChar = f: s:
    let
      firstChar = f (lib.substring 0 1 s);
      rest = lib.substring 1 (-1) s;

      # matched = builtins.match "(.)(.*)" s;
      # firstChar = f (lib.elemAt matched 0);
      # rest = lib.elemAt matched 1;
    in firstChar + rest;

  toCamelCase_ = sep: s:
    mutFirstChar lib.toLower
    (lib.concatMapStrings (mutFirstChar lib.toUpper) (lib.splitString sep s));

  toCamelCase = s:
    builtins.foldl' (s: sep: toCamelCase_ sep s) s [ "-" "_" "." ];

  mkNodeShell = name:
    let node = pkgs.${name};
    in pkgs.mkShell {
      description = "${name} development environment";
      buildInputs = [ node pkgs.nodePackages.pnpm pkgs.bun ];
    };

  mkShell = pkgName: name:
    if lib.strings.hasPrefix "nodejs_" pkgName then
      mkNodeShell name
    else
      builtins.throw "Unknown package ${pkgName} for making shell environment";

  mkShells = pkgName:
    let mkShell_ = mkShell pkgName;
    in builtins.foldl'
    (acc: name: acc // { "${toCamelCase name}" = mkShell_ name; }) { }
    (builtins.filter (lib.strings.hasPrefix pkgName) (builtins.attrNames pkgs));
in mkShells "nodejs_" // rec {
  ccpp = pkgs.mkShell {
    description = "C/C++ development environment";
    buildInputs = with pkgs; [ gcc13 clang clang-tools cmake gnumake ];
  };
}
