{ pkgs, ... }: {
  home.packages = with pkgs;  [
    cliphist
    wl-clipboard
    wofi
    grim
    swappy
    slurp
    pamixer
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
    systemdTarget = "graphical-session.target";
    settings = [
      {
        output.criteria = "eDP-1";
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
