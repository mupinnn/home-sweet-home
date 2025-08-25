{ lib, ... }:

{
  imports = [ ./features/cli ./features/gui ];

  cli.enable = lib.mkDefault true;
  gui.enable = lib.mkDefault false;

  home = {
    username = "mupin";
    homeDirectory = "/home/mupin";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
}
