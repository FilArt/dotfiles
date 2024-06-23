{ pkgs, ... }: {
  home.packages = [ pkgs.pasystray ];
  services.pasystray.enable = true;
}
