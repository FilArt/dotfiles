{ config, pkgs, ... }:

let
  py3 = "${pkgs.python3}/bin/python";
in
{
  home.packages = with pkgs; [
    python3
    bfcal
    hicolor-icon-theme
    gnome-icon-theme
    way-displays
  ];
  home.activation.createQtileConfigDir = ''mkdir -p $HOME/.config/qtile'';
  home.file.".config/qtile/config.py".source = ./config.py;

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
