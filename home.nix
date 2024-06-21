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
    pkgs.nodePackages.pnpm
    cargo
    rustc
    gcc13

    # Overview
    neofetch
    htop

    # Files
    trash-cli
    fzf
    ripgrep
    unzip
    rsync

    # Tools
    bat
    fnm
    tree-sitter
  ];

  # Git
  programs.git = {
    enable = true;
    userName = "Ahmad Muwaffaq";
    userEmail = "itsmupin@gmail.com";
    extraConfig = {
      init = { defaultBranch = "main"; };
      core = {
        editor = "nano";
      };
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

    extraConfig = ''
      set -g prefix C-a
      unbind C-b
      bind C-a send-prefix
    '';
  };

  # zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";

    initExtra = ''
      # fnm
      eval "`fnm env`"
      eval "$(fnm env --use-on-cd)"

      setopt extended_glob
      unsetopt nomatch
    '';

    shellAliases = {
      ll = "ls -l";
      mv = "mv -iv";
      cp = "cp -iv";
      rm = "trash-put";
      cat = "bat";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "fnm"
        "npm"
        "gh"
        "command-not-found"
      ];
      theme = "robbyrussell";
    };
  };
}
