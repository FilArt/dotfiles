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
      btop
      htop-vim
      vlc

      # programming
      lazydocker
      lazygit

      # system
      pinentry
      pavucontrol
      alsa-utils

      # utils
      gnumake
      ripgrep
      p7zip
      rclone
      tree
      ncdu
      duf

      # apps
      telegram-desktop
      slack
      spotify-player
      qbittorrent
      (pkgs.bottles.override {removeWarningPopup = true;})
      streamlink

      # coding
      direnv
      mypy
      uv
      devenv
      # code-cursor
      # alejandra
      python3Packages.ipython
      # python3Packages.debugpy
      # jetbrains.pycharm-professional
    ];
  };

  services.dunst = {
    enable = true;
    iconTheme.name = "Papirus-Dark";
    iconTheme.package = pkgs.papirus-icon-theme;
  };
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        launch-prefix = "uwsm app -- ";
      };
    };
  };
}
