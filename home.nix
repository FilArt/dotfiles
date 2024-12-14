{ config, pkgs, lib, ... }:
{
  imports = [ ./home ];

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  home = {
    username = "art";
    homeDirectory = "/home/art";
    stateVersion = "24.05";
    packages = with pkgs; [
      vulkan-tools
      telegram-desktop
      tree
      ncdu
      direnv
      pavucontrol
      light
      slack
      nixpkgs-fmt
      alsa-utils
      spotify
      gnumake
      rclone
      openfortivpn
      nodePackages_latest.nodejs
      pinentry
      qbittorrent
      python3Packages.ipython
      mypy
      nemo-with-extensions
      screenfetch
      blanket
      btop
      htop-vim
      vlc
      # wf-recorder
      lazydocker
      satty
      jetbrains-toolbox
      bottles
      devenv
      uv
      code-cursor
    ];
  };

  services.network-manager-applet.enable = true;
  services.gnome-keyring.enable = true;
}
