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
    };

    environment.gnome.excludePackages = (with pkgs; [
      epiphany
      geary
      weather
      cheese
      gedit
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
