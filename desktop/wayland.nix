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
}
