{ pkgs, lib, ... }:
{
  imports =
    [
      ./systemd.nix
      ./fonts.nix
    ]
    ++ import ./desktop
    ++ import ./programs;

  programs.home-manager.enable = true;

  home = {
    username = "art";
    homeDirectory = "/home/art";
    stateVersion = "24.05";
    packages = with pkgs; [
      vulkan-tools
      telegram-desktop
      google-chrome
      tree
      ncdu
      direnv
      blueman
      actkbd
      rofi
      haskellPackages.greenclip
      pavucontrol
      jetbrains.pycharm-professional
      light
      slack
      nixpkgs-fmt
      alsa-utils
      spotify
      gnumake
      rclone
      openfortivpn
      wezterm
      nodePackages_latest.nodejs
      pinentry
      qbittorrent
      autorandr
      python3Packages.ipython
      python3Packages.terminaltexteffects
      cinnamon.nemo
      screenfetch
      blanket
    ];
  };

  xdg.enable = true;
  xdg.userDirs.enable = true;

  services.blueman-applet.enable = true;
  services.swaync.enable = true;
  services.network-manager-applet.enable = true;
  services.gnome-keyring.enable = true;
}
