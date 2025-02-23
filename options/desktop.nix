{ lib, ... }: {
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
