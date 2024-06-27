{ config, pkgs, ... }:

let
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  pkill = "${pkgs.procps}/bin/pkill";
  pypr = "${pkgs.pyprland}/bin/pypr";
  py3 = "${pkgs.python3}/bin/python";
in
{
  home.packages = with pkgs;
    [
      pyprland
      hyprlock
      python3
    ];

  wayland.windowManager.hyprland = {
    enable = false;
    package = pkgs.hyprland;
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      general = {
        allow_tearing = true;
      };
      decoration = {
        rounding = 5;
        blur = {
          special = true;
        };
      };
      monitor = [
        "eDP-1,disable"
        "HDMI-A-1,highresxhighrr,auto,1"
        "HDMI-A-1,addreserved,0,0,0,0"
      ];
      env = [
        "XDG_SESSION_DESKTOP,Hyprland"
      ];

      exec-once = [
        "${py3} ${config.home.homeDirectory}/home-manager/desktop/autostart.py"
        "${pypr} --debug /tmp/pypr.log"
      ];

      exec = [
        "${pkill} wpaperd && ${pkgs.wpaperd}/bin/wpaperd &"
        "${pkill} waybar && ${hyprctl} dispatch exec ${pkgs.waybar}/bin/waybar &"
      ];

      "$mod" = "SUPER";

      bind =
        [
          ", Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
          "$mod, D, exec, fuzzel"
          "$mod, E, exec, ${pypr} toggle filemanager"
          "$mod, S, exec, ${pypr} toggle musicplayer"
          "$mod, T, exec, ${pypr} toggle term"
          "$mod, N, exec, ${pypr} toggle volume"
          "$mod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
          "$mod, Return, exec, foot"
          "$mod, Q, killactive"
          "$mod, F, fullscreen"
          "$mod + SHIFT, Q, exec, ${hyprctl} dispatch exit"
          "$mod,Tab,cyclenext,"
          "$mod,Tab,bringactivetotop,"
          "$mod,l,movefocus,r"
          "$mod,h,movefocus,l"
          "$mod,j,movefocus,d"
          "$mod,k,movefocus,u"
          "$mod,right,movefocus,r"
          "$mod,left,movefocus,l"
          "$mod,down,movefocus,d"
          "$mod,up,movefocus,u"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList
            (
              x:
              let
                ws =
                  let
                    c = (x + 1) / 10;
                  in
                  builtins.toString (x + 1 - (c * 10));
              in
              [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            10)
        );

      bindm = [
        # mouse movements
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

      bindl = [
        ",switch:on:Lid Switch,exec,hyprctl keyword monitor \"eDP-1, disable\""
        ",switch:off:Lid Switch,exec,hyprctl keyword monitor \"eDP-1, preferred, 0x0, 1\""
      ];

      input = {
        kb_layout = "us,ru";
        kb_options = "grp:caps_toggle";
      };
    };
  };

  wayland.windowManager.hyprland.systemd.variables = [ "--all" ]; # do i need it?

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
