{ config, pkgs, ... }:

let
  tmuxWorkspaces = {
    me = {
      session_name = "personal";
      start_directory = "~/work/personal";
      windows = [
        {
          window_name = "Editor";
          panes = [ "nvim" ];
        }
        {
          window_name = "Dev server and stuff";
          layout = "even-horizontal";
          panes = [ null null ];
        }
      ];
    };

    work = {
      session_name = "work";
      start_directory = "~/work";
      windows = [
        {
          window_name = "Editor";
          panes = [ "nvim" ];
        }
        {
          window_name = "Dev server and stuff";
          layout = "even-horizontal";
          panes = [ null null ];
        }
      ];
    };
  };

  tmux-kanagawa = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "kanagawa";
    version = "unstable-2025-01-24";
    src = pkgs.fetchFromGitHub {
      owner = "Nybkox";
      repo = "tmux-kanagawa";
      rev = "0d2db8d95e1b74643a06802043c7000a79ba0a0a";
      sha256 = "sha256-9S4HQHuECGLPLdPishmwEO0twdeQ6mZQfIMNFFDkgQ8=";
    };
  };
in {
  home.shellAliases = {
    tme = "tmuxp load ${
        builtins.toFile "tmuxp-me.json" (builtins.toJSON tmuxWorkspaces.me)
      }";
    twork = "tmuxp load ${
        builtins.toFile "tmuxp-work.json" (builtins.toJSON tmuxWorkspaces.work)
      }";
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    prefix = "C-a";
    terminal = "tmux-256color";
    keyMode = "vi";
    clock24 = true;
    historyLimit = 10000;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      pain-control
      yank
      prefix-highlight
      better-mouse-mode
      tmux-kanagawa
    ];

    extraConfig = ''
      set-option -ga terminal-overrides ",xterm-256color:Tc"
      set-option -g status-position top

      # kanagawa theme
      set -g @kanagawa-plugins "attached-clients battery cwd network network-bandwidth time"
      set -g @kanagawa-no-batter-label 
    '';
  };

  programs.tmux.tmuxp.enable = config.programs.tmux.enable;
}
