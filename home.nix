{ config, pkgs, ... }:

{
  home.username = "mupin";
  home.homeDirectory = "/home/mupin";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  imports = [
    ./neovim.nix
  ];

  # Packages
  home.packages = with pkgs; [
    # Development
    jq

    # Overview
    neofetch
    htop

    # Files
    trash-cli
    fzf
    ripgrep

    # Tools
    bat
    tmux
    fnm
  ];

  # Git
  programs.git = {
    enable = true;
    userName = "Ahmad Muwaffaq";
    userEmail = "itsmupin@gmail.com";
    extraConfig = {
      init = { defaultBranch = "main"; };
    };
  };

  # Tmux
  programs.tmux = {
    enable = true;
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      pain-control
      yank
      prefix-highlight
      better-mouse-mode
    ];
  };
}
