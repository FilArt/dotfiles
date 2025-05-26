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
    windowManager.qtile = {
      enable = false;
      extraPackages = p:
        with p; [
          (qtile-extras.overridePythonAttrs (old: {
            disabledTestPaths =
              old.disabledTestPaths
              ++ [
                "test/layout/decorations/test_border_decorations.py"
                "test/popup/test_toolkit.py"
                "test/widget/test_init_configure.py"
              ];
          }))
        ];
    };
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
