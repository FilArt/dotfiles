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

  programs.niri.enable = true;

  programs.uwsm.enable = true;
  programs.uwsm.waylandCompositors = {
    niri = {
      prettyName = "Niri";
      comment = "A scrollable-tiling Wayland compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/niri-session";
    };
  };

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
