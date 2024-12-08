{ config, ... }: {
  programs.waybar = {
    enable = true;
    # settings = {
    #   mainBar = {
    #     height = 34;
    #     modules-left = [ "hyprland/workspaces" ];
    #     modules-center = [ "hyprland/window" ];
    #     modules-right = [
    #       "hyprland/language"
    #       "systemd-failed-units"
    #       "wireplumber"
    #       "pulseaudio#microphone"
    #       "memory"
    #       "disk"
    #       "battery"
    #       "clock"
    #       "tray"
    #       "custom/notification"
    #       "custom/lock"
    #     ];

    #     include = [ "${./waybar.json}" ];

    #     "custom/notification" = {
    #       tooltip = false;
    #       format = "{} {icon}";
    #       "format-icons" = {
    #         notification = "󱅫 ";
    #         none = " ";
    #         "dnd-notification" = "";
    #         "dnd-none" = "󰂛";
    #         "inhibited-notification" = "";
    #         "inhibited-none" = "";
    #         "dnd-inhibited-notification" = "";
    #         "dnd-inhibited-none" = "";
    #       };
    #       "return-type" = "json";
    #       "exec-if" = "which swaync-client";
    #       exec = "swaync-client -swb";
    #       "on-click" = "sleep 0.1 && swaync-client -t -sw";
    #       "on-click-right" = "sleep 0.1 && swaync-client -d -sw";
    #       escape = true;
    #     };
    #   };
    # };

  };

  home.file.".config/waybar/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/home/desktop/waybar/config.jsonc";
  home.file.".config/waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/home/desktop/waybar/style.css";
}
