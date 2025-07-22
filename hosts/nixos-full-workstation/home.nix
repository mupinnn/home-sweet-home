{ pkgs, ... }:
let
  users = import ../../config/users.nix;
in
{
  imports = [../../modules/shared/home-manager.nix];

  home = {
    username = users.default;
    homeDirectory = "/home/${users.default}";
    stateVersion = "25.05";
  };
}