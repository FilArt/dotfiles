{ pkgs, fetchFromGitHub, lib, ... }:
{
  services.xserver = {
    enable = true;
    dpi = 96;
    xkb.layout = "us,ru";
    xkb.options = "grp:caps_toggle";
    windowManager.qtile = {
      enable = true;
      extraPackages = p: with p; [
        (qtile-extras.overridePythonAttrs (old: {
          disabledTestPaths = old.disabledTestPaths ++ [
            "test/widget/test_syncthing.py"
            "test/widget/test_snapcast.py"
            "test/widget/test_githubnotifications.py"
            "test/popup/test_toolkit.py"
            "test/test_images.py"
            "test/widget/test_alsawidget.py"
            "test/widget/test_animated_image.py"
            "test/widget/test_popup_mixin.py"
            "test/widget/test_init_configure.py"
            "test/widget/test_tvhwidget.py"
            "test/widget/test_groupbox2.py"
            "test/widget/test_image.py"
          ];
        }))
      ];
    };
    autorun = false;
    displayManager.lightdm.enable = lib.mkForce false;
  };

  xdg.icons.enable = true;
  xdg.mime.enable = true;

  # xdg.portal = {
  #   enable = true;
  #   config = {
  #     qtile = {
  #       default = [ "wlr" "gtk" ];
  #     };
  #   };
  #   extraPortals = [
  #     pkgs.xdg-desktop-portal-wlr
  #     pkgs.xdg-desktop-portal-gtk
  #   ];
  # };
}
