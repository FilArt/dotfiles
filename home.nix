{ pkgs, lib, ... }:
{
  imports =
    [
      ./services.nix
      ./systemd.nix
      ./desktop/hyprland.nix
      ./desktop/waybar.nix
    ]
    ++ import ./programs/default.nix
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
      dmenu
      autorandr
      python3Packages.ipython
      python3Packages.terminaltexteffects
      cinnamon.nemo
      screenfetch
      blanket

      # fonts
      open-sans
      cascadia-code
      liberation_ttf
      font-awesome
      openmoji-color

      # hyprland
      cliphist # not working very well
      wl-clipboard
      wofi
      grimblast
      emote
      joypixels
      pyprland
    ];
    pointerCursor = {
      gtk.enable = true;
      # x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
      #name = "Vanilla-DMZ";
      #package = pkgs.vanilla-dmz;
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "joypixels"
    ];
  nixpkgs.config.joypixels.acceptLicense = true;

  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.emoji = [ "JoyPixels" ];

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
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "OpenSans";
      size = 11;
    };
    #cursorTheme = {
    #  name = "Vanilla-DMZ";
    #  package = pkgs.vanilla-dmz;
    #};
  };
  home.sessionVariables.GTK_THEME = "Adwaita:dark";

  xdg.enable = true;
  xdg.userDirs.enable = true;
}
