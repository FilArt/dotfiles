{pkgs, ...}: {
  imports = [./home];

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  home = {
    username = "art";
    homeDirectory = "/home/art";
    stateVersion = "24.05";
    packages = with pkgs; [
      ripgrep
      vulkan-tools
      tree
      ncdu
      pavucontrol
      alsa-utils
      gnumake
      rclone
      openfortivpn
      nodePackages_latest.nodejs
      pinentry
      nemo-with-extensions
      btop
      htop-vim
      vlc
      lazydocker
      pasystray
      networkmanagerapplet

      # apps
      telegram-desktop
      slack
      spotify-player
      qbittorrent
      bottles

      # coding:
      direnv
      mypy
      jetbrains-toolbox
      uv
      devenv
      code-cursor
      alejandra
      python3Packages.ipython
      python3Packages.debugpy
    ];
  };
}
