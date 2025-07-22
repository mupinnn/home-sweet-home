let
  users = import ./users.nix;
in
{
  wsl = {
    hostname = "wsl";
    dir = "wsl-workstation";
    arch = "x86_64-linux";
    user = users.default;
  };

  nixosFull = {
    hostname = "nixosFull";
    dir = "nixos-full-workstation";
    arch = "x86_64-linux";
    user = users.default;
  };
}
