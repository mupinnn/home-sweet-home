{ config, pkgs, ... }:

{
  home.username = "mupin";
  home.homeDirectory = "/home/mupin";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

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

    # Tools
    bat
    tmux
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

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      neovim-sensible
      nvim-surround
      nvim-treesitter
      nvim-cmp
      vim-airline
      vim-airline-themes
      vim-airline-clock
      vim-commentary
      vim-indent-guides
      dracula-nvim
    ];
    extraConfig = ''
      syntax enable
      colorscheme dracula

      set cursorline
      set scrolloff=5

      let g:airline_theme='wombat'
    '';
  };
}
