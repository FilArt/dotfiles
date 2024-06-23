{ ... }: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        height = 24;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "sway/language" "systemd-failed-units" "wireplumber" "power-profiles-daemon" "memory" "disk" "tray" "clock" ];
        clock = {
          format = "{:%H:%M %d/%m/%Y %a}";
          tooltip = true;
          calendar = {
            mode = "year";
          };
          actions = {
            "on-click-right" = "mode";
          };
        };
        memory = {
          format = "{percentage}% 💾";
        };
        wireplumber = {
          format = "{volume}% 🎧";
        };
      };
    };
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: "Font Awesome", LiberationSans, Roboto, Helvetica, Arial, sans-serif;
          font-size: 13px;
          min-height: 0;
      }

      window#waybar {
          background: @theme_base_color;
          border-bottom: 1px solid @unfocused_borders;
          color: @theme_text_color;
      }

      #systemd-failed-units, #wireplumber, #power-profiles-daemon, #memory, #disk, #tray, #clock {
        padding-left: 3px;
        padding-right: 3px;
        margin-left: 3px;
        margin-right: 3px;
        background-color: #4E386E;
        border-radius: 5px;
        border: 1px solid #AFE1CE;
      }
    '';
  };
}
