{ ... }: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        height = 24;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "sway/language"
          "systemd-failed-units"
          "wireplumber"
          "power-profiles-daemon"
          "memory"
          "disk"
          "tray"
          "clock"
          "idle_inhibitor"
          "custom/notification"
        ];
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
        disk = {
          interval = 30;
          format = "󱛟 {used}  {free}";
          format-alt-click = "click-right";
          tooltip-format = "{used} used\n{free} free\n{total} total";
          path = "/";
          states = {
            low = 0;
            mid = 25;
            high = 50;
          };
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = " ";
            deactivated = " ";
          };
        };
        "custom/notification" = {
          tooltip = false;
          format = "{} {icon}";
          "format-icons" = {
            notification = "󱅫";
            none = "";
            "dnd-notification" = " ";
            "dnd-none" = "󰂛";
            "inhibited-notification" = " ";
            "inhibited-none" = "";
            "dnd-inhibited-notification" = " ";
            "dnd-inhibited-none" = " ";
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
          font-family: "Font Awesome", Roboto, sans-serif;
          font-size: 13px;
          min-height: 0;
      }

      window#waybar {
          background: @theme_base_color;
          border-bottom: 1px solid @unfocused_borders;
          color: @theme_text_color;
      }

      #systemd-failed-units, #wireplumber, #power-profiles-daemon, #memory, #disk, #tray, #clock, #idle_inhibitor, #custom-notification {
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
