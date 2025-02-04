{ pkgs, devenv, inputs, ... }:

{
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

  nodejs20 = pkgs.mkShell {
    description = "Node.js 20 development environment";
    buildInputs = with pkgs; [ nodejs_20 ];
  };
}
