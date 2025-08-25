{
  imports = [
    ../../homeManagerModules/features/cli
    ../../homeManagerModules/features/gui
  ];

  home = {
    username = "mupin";
    homeDirectory = "/home/mupin";
    stateVersion = "25.05";
  };

  gui.enable = true;

  programs.home-manager.enable = true;
}
