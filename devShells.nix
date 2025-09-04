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

  py_313 = pkgs.mkShell {
    description = "Python v3.13 development environment";
    packages = [
      (pkgs.python313.withPackages (py-pkgs: [
        py-pkgs.numpy
        py-pkgs.pandas
        py-pkgs.scipy
        py-pkgs.matplotlib
        py-pkgs.requests
        py-pkgs.pip
      ]))
      pkgs.poetry
      pkgs.uv
    ];

    env = {
      LD_LIBRARY_PATH =
        pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc pkgs.libz ];
      POETRY_VIRTUALENVS_IN_PROJECT = "true";
      POETRY_VIRTUALENVS_PATH = "{project-dir}/.venv";
      POETRY_VIRTUALENVS_PREFER_ACTIVE_PYTHON = "true";
    };

    shellHook = ''
      venv="$(cd $(dirname $(which python)); cd ..; pwd)"
      ln -Tsf "$venv" .venv
    '';
  };
} // nodeJsShells
