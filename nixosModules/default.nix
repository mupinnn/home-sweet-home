{ lib, pkgs, ... }:

{
  imports = [ ./gnome.nix ];

  gnome.enable = lib.mkDefault true;

  time.timeZone = "Asia/Jakarta";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.mupin = {
    isNormalUser = true;
    description = "mupin";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
