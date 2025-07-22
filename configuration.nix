# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  lib,
  ...
}: let
  locales =
    lib.unique
    (builtins.map (l: (lib.replaceStrings ["utf8" "utf-8" "UTF8"] ["UTF-8" "UTF-8" "UTF-8"] l) + "/UTF-8") [
      "C.UTF-8"
      "en_US.UTF-8"
      "ru_RU.UTF-8"
      "es_ES.UTF-8"
    ]);
in {
  imports =
    [
      ./nix.nix
      ./programs.nix
      ./services.nix
    ]
    ++ import ./options;

  time.timeZone = "Europe/Madrid";
  time.hardwareClockInLocalTime = false;
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.glibcLocales = pkgs.glibcLocalesUtf8.override {
    allLocales = false;
    locales = locales;
  };
  console = {
    useXkbConfig = true; # use xkb.options in tty.
  };

  security.pam.services.login.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;

  security.rtkit.enable = true;

  users.users.art = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "networkmanager" "docker" "video" "audio"];
  };

  environment = {
    systemPackages = with pkgs; [
      xorg.xmodmap
      gcc
      git
      home-manager
      wget
      networkmanager
      docker
      nvtopPackages.full
      pciutils
      lshw
      mesa-demos
      inxi
      xorg.xinit
      power-profiles-daemon
      jq
      cachix
      xwayland-satellite
      nh
      soteria # polkit dialog
    ];
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      QT_SCALE_FACTOR = "1.5";
    };
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      inter-nerdfont
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      nerd-fonts.roboto-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.droid-sans-mono
      nerd-fonts.fira-code
      font-awesome
      material-design-icons
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      roboto
      roboto-serif
      openmoji-color
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Roboto Serif" "Liberation Serif" "DejaVu Serif" "Noto Serif"];
        sansSerif = ["Inter Nerd Font" "Roboto" "Libration Sans" "DejaVu Sans" "Noto Sans"];
        monospace = ["RobotoMono" "Droid Sans Mono" "Fira Code"];
        emoji = ["OpenMoji Color" "JoyPixels" "Noto Color Emoji"];
      };
    };
  };

  system = {
    stateVersion = "24.05";
  };
}
