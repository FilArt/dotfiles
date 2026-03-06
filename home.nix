{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./home
  ];

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
      python3
      antigravity

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
      devenv

      inputs.codex-cli-nix.packages.${stdenv.hostPlatform.system}.default

      # dms
      dsearch
      inputs.opencode.packages.${stdenv.hostPlatform.system}.default
    ];
  };
}
