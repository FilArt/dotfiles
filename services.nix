{ lib, ... }: {
  services.borgmatic.enable = true;
  services.pasystray.enable = true;
  services.blueman-applet.enable = true;
  #services.dunst.enable = true;
  services.swaync.enable = true;
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
  services.network-manager-applet.enable = true;
  services.gnome-keyring.enable = true;
  services.parcellite.enable = true;
  services.redshift.enable = true;
  services.redshift.provider = "geoclue2";
}
