{ config, pkgs, ... }:

let
  tmuxWorkspaces = {
    me = {
      session_name = "[ME] Personal";
      shell_command_before = [ "cd ~/work/personal" ];
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
      shell_command_before = [ "cd ~/work" ];
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

  programs.tmux.tmuxp.enable = config.programs.tmux.enable;
}
