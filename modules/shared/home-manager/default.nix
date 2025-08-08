{ pkgs, inputs, ... }:

{
  programs.home-manager.enable = true;

  imports = [ inputs.nixvim.homeManagerModules.nixvim ./nixvim.nix ./git.nix ./tmux.nix ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  home.packages = with pkgs; [
    # Development
    jq
    android-tools
    devenv

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

  programs.direnv = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    nix-direnv.enable = true;
  };

  # nix-index (nix-locate) to easily find nix package by its name
  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";

    initContent = ''
      setopt extended_glob
      setopt PROMPT_SUBST
      unsetopt nomatch

      if [ -z "$SSH_AUTH_SOCK" ] ; then
        eval "$(ssh-agent -s)" > /dev/null
        find ~/.ssh -name "id_*" ! -name "*.pub" -exec ssh-add -q {} \;
      fi

      # direnv.enableZshIntegration
      eval "$(${pkgs.direnv}/bin/direnv hook zsh)"

      show_nix_shell() {
        if [ -n "$IN_NIX_SHELL" ] ; then
          echo "( $(basename $IN_NIX_SHELL)) "
        fi
      }

      export DISABLE_AUTO_TITLE='true'
      export PS1=$PS1'$(show_nix_shell)'
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
      plugins = [ "git" "npm" "gh" "command-not-found" ];
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