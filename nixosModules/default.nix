{ lib, ... }:

{
  imports = [ ./gnome.nix ];

  gnome.enable = lib.mkDefault true;

  time.timeZone = "Asia/Jakarta";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.mupin = {
    isNormalUser = true;
    description = "mupin";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.firefox.enable = true;
}
