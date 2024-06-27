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
    GDK_BACKEND = "wayland,x11,*";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
  };

  services.kanshi.enable = true;
  services.kanshi.systemdTarget = "graphical-session.target";
  services.kanshi.settings = [
    {
      profile.name = "docked";
      profile.outputs = [
        {
          criteria = "eDP-1";
          status = "disable";
        }
        {
          criteria = "HDMI-A-1";
          mode = "1920x1080";
          adaptiveSync = true;
          position = "0,0";
          scale = 1.0;
        }
      ];
    }
    {
      profile.name = "undocked";
      profile.outputs = [
        {
          criteria = "eDP-1";
        }
      ];
    }
  ];
}
