{ pkgs, ... }:

{
  home.username = "mupin";
  home.homeDirectory = "/home/mupin";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  nix = {
    package = pkgs.nix;
    settings = { experimental-features = [ "nix-command" "flakes" ]; };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  imports = [ ./nixvim.nix ./git.nix ./tmux.nix ];

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

    # Tools
    bat
    fnm
    tree
    tree-sitter
    gnupg
    curl
    wget
    cowsay
  ];

  # nix-index (nix-locate) to easily find nix package by its name
  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
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

      if [ -z "$SSH_AUTH_SOCK" ] ; then
        eval "$(ssh-agent -s)" > /dev/null
        find ~/.ssh -name "id_*" ! -name "*.pub" -exec ssh-add -q {} \;
      fi

      export DISABLE_AUTO_TITLE='true'
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
      plugins = [ "git" "fnm" "npm" "gh" "command-not-found" ];
      theme = "robbyrussell";
    };
  };

  # ssh
  # programs.ssh.addKeysToAgent = "yes";
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };
}
