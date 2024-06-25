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
          "pulseaudio#microphone"
          "memory"
          "disk"
          "battery"
          "clock"
          "tray"
          "custom/notification"
          "custom/lock"
        ];

        include = [ "${./waybar.json}" ];

        "custom/notification" = {
          tooltip = false;
          format = "{} {icon}";
          "format-icons" = {
            notification = "󱅫 ";
            none = " ";
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
        min-height: 0;
        font-weight: bold;
        /* set font-size to 100% if font scaling is set to 1.00 using nwg-look */
        font-size: 97%;
        font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
      }

      #systemd-failed-units, 
      #wireplumber, 
      #pulseaudio, 
      #memory, 
      #disk, 
      #tray, 
      #clock, 
      #custom-notification, 
      #hyprland-language, 
      #battery, 
      #custom-lock 
      {
        padding-left: 3px;
        padding-right: 3px;
        margin-left: 3px;
        margin-right: 3px;
        border-radius: 5px;
        color: #e5d9f5;
      }
      #systemd-failed-units:hover, 
      #wireplumber:hover, 
      #pulseaudio:hover, 
      #memory:hover, 
      #disk:hover, 
      #tray:hover, 
      #clock:hover, 
      #custom-notification:hover, 
      #hyprland-language:hover, 
      #battery:hover, 
      #custom-lock:hover 
      {
        background-color: #4B0082;
      }

      #custom-lock {
        margin: 0 6px 0 3px;
      }

      window#waybar {
        border-bottom: 1px solid @unfocused_borders;
        background: #040406;
        border-radius: 30px;
        color: #cba6f7;
      }

      window#waybar.hidden {
        opacity: 0.5;
      }

      window#waybar.empty,
      window#waybar.empty #window {
        padding: 0px;
        border: 0px;
        background-color: transparent;
      }

      tooltip {
        background: #1e1e2e;
        border-radius: 10px;
        border-width: 2px;
        border-style: solid;
        border-color: #11111b;
        color: #ffd700;
      }

      #workspaces button {
          color: #6E6A86;
          box-shadow: none;
          text-shadow: none;
          padding: 0px;
          border-radius: 9px;
          padding-left: 4px;
          padding-right: 4px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.682);
      }

      #taskbar button.active,
      #workspaces button.active {
          color: #ffd700;
          border-radius: 50%;
          background-color: black;
          border-radius: 15px 15px 15px 15px;
          padding-left: 8px;
          padding-right: 8px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
      }

      #workspaces button.focused {
          color: #d8dee9;
      }

      #workspaces button.urgent {
          color: #11111b;
          border-radius: 10px;
      }

      #taskbar button:hover,
      #workspaces button:hover {
          color: #ffd700;
          border-radius: 15px;
        padding-left: 2px;
          padding-right: 2px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
      }

    '';
  };
}
