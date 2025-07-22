{ pkgs, ... }:

{
  programs.home-manager.enable = true;

  # Packages
  home.packages = with pkgs; [
    # Development
    jq
    android-tools

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
    zip

    # Tools
    bat
    tree
    tree-sitter
    gnupg
    curl
    wget
  ];
}