{ config, pkgs, ... }:

{
  home.username = "mupin";
  home.homeDirectory = "/home/mupin";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  imports = [
    ./neovim.nix
    ./git.nix
  ];

  # Packages
  home.packages = with pkgs; [
    # Development
    jq
    pkgs.nodePackages.pnpm
    cargo
    rustc
    gcc13
    bun
    gnumake
    cmake
    (hiPrio clang)

    # Overview
    neofetch
    btop

    # Files
    trash-cli
    fzf
    ripgrep
    unzip
    rsync
    xclip

    # Tools
    bat
    fnm
    tree
    tree-sitter
    gnupg
    curl
    wget
  ];

  # nix-index (nix-locate) to easily find nix package by its name
  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  # Tmux
  programs.tmux = {
    enable = true;
    mouse = true;
    prefix = "C-a";
    terminal = "xterm-256color";
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      pain-control
      yank
      prefix-highlight
      better-mouse-mode
    ];

    extraConfig = ''
      set-option -ga terminal-overrides ",xterm-256color:Tc"
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
