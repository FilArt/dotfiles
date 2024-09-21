# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
{
  imports =
    [
      <nixos-hardware/common/cpu/intel>
      ./hardware-configuration.nix
      ./audio.nix
      ./gamescope.nix
    ];

  nix.settings.trusted-users = [ "root" "@wheel" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };
  boot.kernelParams = [
    "mitigations=off"
    "nowatchdog"
    "nmi_watchdog=0"
    "usbcore.autosuspend=120" # 2 minutes
  ];
  boot.blacklistedKernelModules = [ "iTCO_wdt" ];
  boot.tmp.cleanOnBoot = true;
  boot.tmp.useTmpfs = true;
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;

  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    wireless.enable = false; # disable wpa_supplicant

    firewall = {
      enable = false; # pycharm docker debug not working with firewall
      allowPing = false;
      allowedTCPPorts = [ 42971 ];
    };
  };

  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" ];
  console = {
    font = "Lat2-Terminus16";
    #keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  xdg.icons.enable = true;
  xdg.mime.enable = true;

  xdg.portal = {
    enable = true;
    config = {
      qtile = {
        default = [ "wlr" "gtk" ];
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    dpi = 96;
    xkb.layout = "us,ru";
    xkb.options = "grp:caps_toggle";
    windowManager.qtile = {
      enable = true;
      extraPackages = p: with p; [
        qtile-extras
        dbus-next
        pyxdg
      ];
    };
    updateDbusEnvironment = true;
    displayManager.lightdm.enable = false;
  };

  programs.gdk-pixbuf.modulePackages = with pkgs; [ gdk-pixbuf librsvg ]; # fix qtile tray
  programs.hyprland = {
    # or wayland.windowManager.hyprland
    enable = false;
    xwayland.enable = true;
  };
  programs.gamemode.enable = true;
  services.gvfs.enable = true;
  services.fstrim.enable = true;
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';
  services.printing.enable = false;
  services.upower.enable = true;
  security.rtkit.enable = true;
  services.fwupd.enable = true;
  services.dnsmasq = {
    enable = true;
    settings.server = [
      "8.8.8.8"
      "8.8.4.4"
    ];
  };
  powerManagement.enable = false;
  powerManagement.powertop.enable = false;
  services.thermald.enable = true;
  services.tlp = {
    enable = false;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 60;
    };
  };

  security.pam.services.hyprlock = { };

  nixpkgs.config.allowUnfree = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

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

  services.blueman.enable = true;
  services.throttled.enable = false;
  services.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    git
    home-manager
    wget
    networkmanager
    docker
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  fileSystems = {
    "/home/art/mnt/hdd" = {
      device = "/dev/disk/by-uuid/7423da92-0ea2-430d-bb30-8d02f438679c";
      fsType = "btrfs";
      options = [
        "defaults"
        "rw"
        "user"
        "nofail"
        "compress=zstd"
        "suid"
        "dev"
        "exec"
        "auto"
        "nouser"
        "async"
      ];
    };
  };

  services.btrfs.autoScrub.enable = true;

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
