{ config, pkgs, ... }:

let
  py3 = "${pkgs.python3}/bin/python";


in
{
  home.packages = with pkgs; [
    python3
  ];
  home.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "qtile";
  };
  home.activation.createQtileConfigDir = ''
    mkdir -p $HOME/.config/qtile
  '';
  home.file.".config/qtile/config.py".source = ./config.py;

  home.file.".dbus-qtile-environment" = {
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=qtile
      systemctl --user stop xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk
      systemctl --user start xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk
    '';

  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gnome
    (pkgs.xdg-desktop-portal-gtk.override {
      # Do not build portals that we already have.
      buildPortalsInGnome = false;
    })
    pkgs.gnome.gnome-shell
  ];
  xdg.portal.config = {
    common = {
      default = [
        "gtk"
      ];
    };
  };
  xdg.portal.configPackages = [
    pkgs.gnome.gnome-session
  ];
}
