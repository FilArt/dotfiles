# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{pkgs, ...}: {
  imports =
    [
      ./nix.nix
      ./programs.nix
      ./services.nix
    ]
    ++ import ./options;

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "ru_RU.UTF-8";
  i18n.supportedLocales = ["en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" "es_ES.UTF-8/UTF-8"];
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    useXkbConfig = true; # use xkb.options in tty.
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.uwsm.enableGnomeKeyring = true;
  };
  services.gnome.gnome-keyring.enable = true;

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };
  };

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
    ];
    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      nerd-fonts.roboto-mono
      nerd-fonts.jetbrains-mono
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
        sansSerif = ["Roboto" "Libration Sans" "DejaVu Sans" "Noto Sans"];
        monospace = ["RobotoMono"];
        emoji = ["OpenMoji Color" "JoyPixels" "Noto Color Emoji"];
      };
    };
  };

  system = {
    stateVersion = "24.05";
  };
}
