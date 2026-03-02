{
  inputs,
  pkgs,
  ...
}: let
  grim = "${pkgs.grim}/bin/grim -t ppm";
  slurp = "${pkgs.slurp}/bin/slurp -d";
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
  satty = "${pkgs.satty}/bin/satty -f - --copy-command=${wl-copy} --actions-on-escape=\"save-to-clipboard,exit\" --disable-notifications";
in {
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
    inputs.niri.homeModules.niri
  ];

  nixpkgs.overlays = [inputs.niri.overlays.niri];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
    settings = {
      environment."NIXOS_OZONE_WL" = "1";

      window-rules = [
        {
          clip-to-geometry = true;
          geometry-corner-radius = {
            bottom-left = 5.0;
            bottom-right = 5.0;
            top-left = 5.0;
            top-right = 5.0;
          };
        }
      ];

      binds = {
        # spawn
        "Mod+E".action.spawn = ["nemo"];
        "Mod+Z".action.spawn = ["kitty" "--hold" "zsh" "-c" "zellij"];

        "Mod+Shift+E".action.quit.skip-confirmation = true;
        "Mod+Shift+S".action.spawn = [
          "sh"
          "-c"
          "${grim} -g \"$(${slurp})\" - | ${satty}"
        ];
        "Mod+Shift+J".action.spawn = [
          "kitty"
          "--hold"
          "zsh"
          "-c"
          "journalctl -f"
        ];

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        "Mod+Ctrl+1".action.move-column-to-workspace = 1;
        "Mod+Ctrl+2".action.move-column-to-workspace = 2;
        "Mod+Ctrl+3".action.move-column-to-workspace = 3;
        "Mod+Ctrl+4".action.move-column-to-workspace = 4;
        "Mod+Ctrl+5".action.move-column-to-workspace = 5;
        "Mod+Ctrl+6".action.move-column-to-workspace = 6;
        "Mod+Ctrl+7".action.move-column-to-workspace = 7;
        "Mod+Ctrl+8".action.move-column-to-workspace = 8;
        "Mod+Ctrl+9".action.move-column-to-workspace = 9;

        "Mod+Q".action.close-window = {};
        "Mod+F".action.maximize-column = {};
        "Mod+Shift+F".action.fullscreen-window = {};
        "Mod+Shift+P".action.screenshot-screen = {show-pointer = false;};

        "Mod+Left".action.focus-column-left = {};
        "Mod+Right".action.focus-column-right = {};
        "Mod+Up".action.focus-window-up = {};
        "Mod+Down".action.focus-window-down = {};

        "Mod+Ctrl+Left".action.move-column-left = {};
        "Mod+Ctrl+Right".action.move-column-right = {};
        "Mod+Ctrl+Up".action.move-window-up = {};
        "Mod+Ctrl+Down".action.move-window-down = {};

        "Mod+Page_Down".action.focus-workspace-down = {};
        "Mod+Page_Up".action.focus-workspace-up = {};

        "Mod+Shift+Comma".action.consume-window-into-column = {};
        "Mod+Shift+Period".action.expel-window-from-column = {};

        "Mod+C".action.center-column = {};
      };
    };
  };

  programs.dank-material-shell = {
    enable = true;
    niri = {
      # enableKeybinds = true; # Sets static preset keybinds
      enableSpawn = true; # Auto-start DMS with niri and cliphist, if enabled
      includes = {
        enable = true;
        override = true;
        originalFileName = "hm";
        filesToInclude = [
          "alttab"
          "binds"
          "colors"
          "layout"
          "outputs"
          "wpblur"
          "cursor"
        ];
      };
    };
    enableSystemMonitoring = true;
    enableAudioWavelength = true;

    plugins = {
      DockerManager = {
        src = pkgs.fetchFromGitHub {
          owner = "LuckShiba";
          repo = "DmsDockerManager";
          rev = "v1.2.0";
          sha256 = "sha256-VoJCaygWnKpv0s0pqTOmzZnPM922qPDMHk4EPcgVnaU=";
        };
      };
    };
  };
}
