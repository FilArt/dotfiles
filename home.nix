{
  config,
  pkgs,
  lib,
  ...
}: {
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
      telegram-desktop
      tree
      ncdu
      direnv
      pavucontrol
      slack
      nixpkgs-fmt
      alsa-utils
      spotify-player
      gnumake
      rclone
      openfortivpn
      nodePackages_latest.nodejs
      pinentry
      qbittorrent
      python3Packages.ipython
      mypy
      nemo-with-extensions
      btop
      htop-vim
      vlc
      lazydocker
      jetbrains-toolbox
      bottles
      devenv
      uv
      code-cursor
      pasystray
      networkmanagerapplet
      alejandra
    ];
  };
  services.gnome-keyring.enable = true;
}
