{ pkgs, ... }:
{
  imports =
    [
      ./programs.nix
      ./services.nix
      ./systemd.nix
    ]
    ++ import ./desktop
    ++ [
      <catppuccin/modules/home-manager>
    ];

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
      redshift
      blueman
      actkbd
      pasystray

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
      emojione
      qbittorrent
      tela-circle-icon-theme
      gnome.nautilus
      dmenu
      autorandr
      python3Packages.ipython
      cinnamon.nemo
      pop-gtk-theme

      # fonts
      open-sans
      cascadia-code
      liberation_ttf
      font-awesome
      openmoji-color

      # hyprland
      cliphist
      wl-clipboard-rs
      wofi
      grimblast
      emote
    ];
    pointerCursor = {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
    };
  };

  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.emoji = [ "EmojiOne Color" "Noto Color Emoji" ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  qt = {
    enable = true;
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
    platformTheme.name = "adwaita";
  };

  gtk = {
    enable = true;
    theme.name = "Pop-dark";
    iconTheme.name = "Tela-circle-dark";
    font = {
      name = "OpenSans";
      size = 11;
    };
  };

  xdg.enable = true;
  xdg.userDirs.enable = true;
}
