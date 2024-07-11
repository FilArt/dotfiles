{ pkgs, ... }: {
  home.packages = with pkgs;  [
    cliphist
    wl-clipboard
    grim
    swappy
    slurp
    pamixer
    rofi-wayland-unwrapped
  ];

  home.sessionVariables = {
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    XDG_CURRENT_DESKTOP = "qtile";
  };

  services.swaync.enable = true;
  services.kanshi = {
    enable = true;
    systemdTarget = "tray.target";
    settings = [
      {
        output = {
          criteria = "eDP-1";
          position = "0,0";
        };
      }
      {
        output = {
          criteria = "HDMI-A-1";
          #position = "1920,0";
          scale = 2.0;
        };
      }
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
          }
        ];
      }
      {
        profile.name = "docked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "HDMI-A-1";
          }
        ];
      }
    ];
  };
}
