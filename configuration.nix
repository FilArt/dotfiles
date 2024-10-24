# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
{
  imports =
    [
      <nixos-hardware/common/gpu/amd>
    ]
    ++ import ./options
  ;

  nix.settings.trusted-users = [ "root" "@wheel" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" ];
  console = {
    font = "Lat2-Terminus16";
    #keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  programs.gamemode.enable = true;
  services.gvfs.enable = true;
  services.fstrim.enable = true;
  services.printing.enable = false;
  security.rtkit.enable = true;
  services.fwupd.enable = true;
  services.dnsmasq = {
    enable = true;
    settings.server = [
      "8.8.8.8"
      "8.8.4.4"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  users.users.art = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "audio" ];
  };
  programs.zsh.enable = true;
  programs.dconf.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.steam.enable = true;
  #programs.steam.gamescopeSession.enable = true;

  environment.systemPackages = with pkgs; [
    git
    home-manager
    wget
    networkmanager
    docker
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  system.copySystemConfiguration = true;
  system.autoUpgrade.enable = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.settings.auto-optimise-store = true;
  system.stateVersion = "24.05";
}
