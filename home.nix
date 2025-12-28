{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./home
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
    inputs.niri.homeModules.niri
  ];

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.niri.enable = true;
  programs.niri.settings.environment."NIXOS_OZONE_WL" = "1";
  programs.niri.settings = {
    binds = {
      # spawn
      "Mod+E".action.spawn = ["nemo"];
      "Mod+Z".action.spawn = ["kitty" "--hold" "zsh" "-c" "zellij"];

      "Mod+Shift+E".action.quit.skip-confirmation = true;

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

  programs.dank-material-shell = {
    enable = true;
    niri = {
      enableKeybinds = true; # Sets static preset keybinds
      enableSpawn = true; # Auto-start DMS with niri and cliphist, if enabled
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

  home = {
    username = "art";
    homeDirectory = "/home/art";
    stateVersion = "24.05";
    packages = with pkgs; [
      vulkan-tools
      openfortivpn
      nodePackages_latest.nodejs
      nemo-with-extensions
      vlc

      # programming
      lazydocker
      lazygit

      # system
      pinentry-gnome3 # dialogs
      pavucontrol
      alsa-utils

      # utils
      gnumake
      ripgrep
      p7zip
      rclone
      tree
      ncdu

      # apps
      telegram-desktop
      slack
      spotify-player
      qbittorrent
      (pkgs.bottles.override {removeWarningPopup = true;})

      # coding
      direnv
      devenv
    ];
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      alias ll='ls -lah'
    '';
  };
}
