let
  users = import ./users.nix;
in
{
  # My main PC, running Ubuntu on WSL 2.
  # Specs: Ryzen 5 5600, RX 6600, and 32GB RAM.
  barbatos = {
    hostname = "barbatos";
    dir = "barbatos";
    arch = "x86_64-linux";
    user = users.default;
  };

  # My main laptop, running NixOS.
  # Specs: Ryzen 7 6800H, and 16GB RAM.
  nixProvidence = {
    hostname = "nixProvidence";
    dir = "nix-providence";
    arch = "x86_64-linux";
    user = users.default;
  };
}
