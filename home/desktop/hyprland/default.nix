{
  config,
  pkgs,
  ...
}: let
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  pkill = "${pkgs.procps}/bin/pkill";
  pypr = "${pkgs.pyprland}/bin/pypr";
  py3 = "${pkgs.python3}/bin/python";
in {
  home.packages = with pkgs; [
    pyprland
    hyprlock
    python3
    hyprpolkitagent
  ];

  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    environment = {
      TERM = "xterm-256color";
    };
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
    };
  };

  home.file.".config/hypr/pyprland.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/home/programs/pyprland/pyprland.toml";
  home.file.".config/hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/home/desktop/hyprland/hyprland.conf";

  programs.hyprlock = {
    enable = true;
    settings = {
      background = [
        {
          monitor = "";
          path = "${config.home.homeDirectory}/Pictures/wallpapers/1.png";
          blur_passes = 3;
          blur_size = 4;
        }
      ];
      input-field = [
        {
          monitor = "";
          size = "200, 50";
          position = "0, -80";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = "say friend and enter";
          shadow_passes = 2;
        }
      ];
    };
  };

  programs.wpaperd = {
    enable = true;
    settings = {
      default = {
        duration = "30m";
        mode = "center";
        sorting = "ascending";
      };
      any = {
        path = "${config.home.homeDirectory}/Pictures/wallpapers";
      };
    };
  };
}
