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
  };

  services.swaync.enable = true;
}
