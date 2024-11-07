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


  services.swaync.enable = true;
  services.kanshi = {
    enable = true;
    systemdTarget = "";
    settings = [
      {
        profile.outputs = [
          {
            criteria = "HDMI-A-1";
            scale = 2.0;
          }
                  ];
      }
      {
        profile.outputs = [
          {
            criteria = "HDMI-A-2";
            scale = 2.0;
          }
        ];
      }
    ];
  };
}
