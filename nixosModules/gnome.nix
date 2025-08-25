{ pkgs, lib, config, ... }:

{
  options = {
    gnome.enable = lib.mkEnableOption "Enable GNOME desktop environment";
  };

  config = lib.mkIf config.gnome.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      xkb = {
        layout = "us";
        variant = "";
      };

      excludePackages = with pkgs; [ xterm ];
    };

    environment.gnome.excludePackages = (with pkgs; [
      epiphany
      geary
      cheese
      gedit
      weather
      simple-scan
      yelp
      gnome-font-viewer
      gnome-text-editor
      gnome-extensions-cli
      gnome-shell-extensions
      gnome-extension-manager
      gnome-weather
      gnome-software
      gnome-maps
      gnome-connections
      gnome-photos
      gnome-tour
      gnome-contacts
      gnome-music
      gnome-characters
      gnome-initial-setup
      gnome-calendar
    ]);
  };
}
