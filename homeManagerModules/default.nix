{ lib, ... }:

{
  imports = [ ./features/cli ./features/gui ];

  cli.enable = lib.mkDefault true;
  gui.enable = lib.mkDefault false;

  home = {
    username = "mupin";
    homeDirectory = "/home/mupin";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
