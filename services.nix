{ lib, ... }: {
  services.pasystray.enable = true;
  services.blueman-applet.enable = true;
  services.swaync.enable = true;
  services.network-manager-applet.enable = true;
  services.gnome-keyring.enable = true;
  services.redshift.enable = true;
  services.redshift.provider = "geoclue2";
}
