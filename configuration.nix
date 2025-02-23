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
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = ["en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8"];
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
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  users.users.art = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "networkmanager" "docker" "video" "audio"];
  };

  environment = {
    systemPackages = with pkgs; [
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
    ];
    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  system = {
    stateVersion = "24.05";
  };
}
