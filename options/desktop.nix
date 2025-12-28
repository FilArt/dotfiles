{
  lib,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;
    dpi = 96;
    xkb.layout = "us,ru";
    xkb.options = "grp:caps_toggle";
    autorun = false;
    displayManager.lightdm.enable = lib.mkForce false;
  };

  services.displayManager.gdm.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs;
      lib.mkForce [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
    config = {
      common = {
        default = [
          "gtk"
        ];
        "org.freedesktop.impl.portal.Secret" = [
          "gnome-keyring"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = [
          "gnome"
        ];
      };
    };
  };
}
