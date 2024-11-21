{ pkgs, ... }: {
  home.packages = with pkgs;  [
    wf-recorder
    cliphist
    wl-clipboard
    grim
    swappy
    slurp
    pamixer
    rofi-wayland-unwrapped
    wlr-randr
  ];

  services.swaync.enable = true;
}
