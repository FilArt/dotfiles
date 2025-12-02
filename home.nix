{pkgs, ...}: {
  imports = [./home];

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

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

      playerctl # used in niri.kdl
      gsimplecal # used in waybar
    ];
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        launch-prefix = "uwsm app -- ";
      };
    };
  };

  programs.bash = {
    enable = true;
    profileExtra = ''
      export EDITOR=helix
      export PATH="$HOME/.local/bin:$PATH"
    '';
    initExtra = ''
      alias ll='ls -lah'
    '';
  };
}
