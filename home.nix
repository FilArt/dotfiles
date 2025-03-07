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
      lazydocker

      # system
      pinentry
      pavucontrol
      alsa-utils
      networkmanagerapplet

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

  services.dunst = {
    enable = true;
    iconTheme.name = "Papirus-Dark";
    iconTheme.package = pkgs.papirus-icon-theme;
  };
  programs.fuzzel.enable = true;
  services.blueman-applet.enable = true;
  services.network-manager-applet.enable = true;
}
