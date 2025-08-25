{ lib, config, pkgs, ... }:

{
  options = { gui.enable = lib.mkEnableOption "Enable GUI apps"; };

  config = lib.mkIf config.gui.enable {
    home.packages = with pkgs; [
      google-chrome
      firefox
      obsidian
      davinci-resolve
      bitwarden
    ];
  };
}
