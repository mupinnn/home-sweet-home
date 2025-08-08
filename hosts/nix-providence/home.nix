{ host, ... }:

{
  imports = [../../modules/shared/home-manager];

  home = {
    username = host.user;
    homeDirectory = "/home/${host.user}";
    stateVersion = "25.05";
  };
}