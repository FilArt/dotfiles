{ ... }: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        height = 26;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "hyprland/language"
          "systemd-failed-units"
          "wireplumber"
          "memory"
          "disk"
          "tray"
          "clock#2"
          "clock#3"
          "clock#1"
          "battery"
          "idle_inhibitor"
          "custom/notification"
          "custom/lock"
        ];

        include = [ "${./waybar.json}" ];


        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "  ";
            deactivated = " ";
          };
        };
        "custom/notification" = {
          tooltip = false;
          format = "{} {icon}";
          "format-icons" = {
            notification = "󱅫";
            none = "";
            "dnd-notification" = "";
            "dnd-none" = "󰂛";
            "inhibited-notification" = "";
            "inhibited-none" = "";
            "dnd-inhibited-notification" = "";
            "dnd-inhibited-none" = "";
          };
          "return-type" = "json";
          "exec-if" = "which swaync-client";
          exec = "swaync-client -swb";
          "on-click" = "sleep 0.1 && swaync-client -t -sw";
          "on-click-right" = "sleep 0.1 && swaync-client -d -sw";
          escape = true;
        };
      };
    };
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: "Font Awesome", RobotoMono Nerd Font, sans-serif;
          font-size: 13px;
          min-height: 0;
      }

      window#waybar {
          background: @theme_base_color;
          border-bottom: 1px solid @unfocused_borders;
          color: @theme_text_color;
      }

      #systemd-failed-units, #wireplumber, #memory, #disk, #tray, #clock, #idle_inhibitor, #custom-notification, #hyprland-language, #battery, #custom-lock {
        padding-left: 3px;
        padding-right: 3px;
        margin-left: 3px;
        margin-right: 3px;
        background-color: #4E386E;
        border-radius: 5px;
        border: 1px solid #AFE1CE;
      }

      #tray {
        background-color: black;
      }
    '';
  };
}
