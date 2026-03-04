{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    inputs.dms.nixosModules.greeter
    inputs.dms.nixosModules.dank-material-shell
  ];

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    systemd.restartIfChanged = true; # Auto-restart dms.service when dank-material-shell changes
    enableSystemMonitoring = true;
    enableAudioWavelength = true;
    enableVPN = true; # VPN management widget
    enableDynamicTheming = true; # Wallpaper-based theming (matugen)
    enableCalendarEvents = true; # Calendar integration (khal)
    enableClipboardPaste = true; # Pasting items from the clipboard (wtype)
  };

  programs.dank-material-shell.greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = "/home/art";
  };

  programs.niri.enable = true;

  environment = {
    systemPackages = with pkgs; [
      xdg-desktop-portal
    ];
    variables = {
      XDG_SESSION_TYPE = "wayland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      # export GDK_BACKEND="wayland,x11,*"

      # For Firefox to run on Wayland
      MOZ_ENABLE_WAYLAND = 1;
      MOZ_WEBRENDER = 1;

      # For Electron apps to run on Wayland
      NIXOS_OZONE_WL = 1;
      ELECTRON_OZONE_PLATFORM_HINT = "auto";

      # QT
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "gtk3";
      QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_SCALE_FACTOR = "1.5";
      QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      # Misc
      _JAVA_AWT_WM_NONEREPARENTING = "1";
    };
  };

  # use dms polkit
  systemd.user.services.niri-flake-polkit.enable = false;

  xdg.portal = {
    enable = true;
    wlr.enable = false;
    xdgOpenUsePortal = false;

    config.common = {
      default = [
        "gtk"
        "gnome"
      ];
      "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
      "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
      "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
    };

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
  };
}
