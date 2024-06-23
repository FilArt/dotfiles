{ pkgs, ... }: {
  home.packages = with pkgs; [
    cliphist # not working very well
    wl-clipboard
    wofi
    grimblast
    pyprland
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      monitor = "eDP-1,disable";
      decoration = {
        shadow_offset = "0 5";
        "col.shadow" = "rgba(00000099)";
      };

      env = [
        "GDK_BACKEND,wayland,x11,*"
        "QT_QPA_PLATFORM,wayland;xcb"
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_QPA_PLATFORMTHEME,qt5ct"
      ];

      exec-once = [
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "hyprctl dispatch exec waybar"
        "${pkgs.pyprland}/bin/pypr"
        "${pkgs.ianny}/bin/ianny"
      ];

      "$mod" = "SUPER";

      bind =
        [
          ", Print, exec, grimblast copy area"
          "$mod, D, exec, fuzzel"
          "$mod, E, exec, pypr toggle filemanager"
          "$mod, S, exec, pypr toggle musicplayer"
          "$mod, T, exec, pypr toggle term"
          "$mod, N, exec, pypr toggle volume"
          "$mod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
          "$mod, Return, exec, foot"
          "$mod, Q, killactive"
          "$mod, F, fullscreen"
          "$mod + SHIFT, Q, exec, hyprctl dispatch exit"
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

      input = {
        kb_layout = "us,ru";
        kb_options = "grp:caps_toggle";
      };
    };
  };

  wayland.windowManager.hyprland.systemd.variables = [ "--all" ]; # do i need it?
}
