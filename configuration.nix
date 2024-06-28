# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.kernelParams = [
    "mitigations=off"
    "nowatchdog"
    "nmi_watchdog=0"
  ];
  boot.blacklistedKernelModules = [ "iTCO_wdt" ];
  boot.tmp.cleanOnBoot = true;
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

  sound.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Madrid";
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    #keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    dpi = 96;
    config = ''
      Section "Device"
        Identifier "Intel Graphics"
        Driver "intel"

        Option "TearFree" "true"
        Option "TripleBuffer" "true"
      EndSection
    '';
    xkb.layout = "us,ru";
    xkb.options = "grp:caps_toggle";
    windowManager.qtile = {
      enable = true;
      extraPackages = python3Packages: with python3Packages; [
        qtile-extras
        dbus-next
        pyxdg
        pywlroots
        pywayland
        xkbcommon
      ];
    };
    displayManager.gdm.enable = false;
    updateDbusEnvironment = true;
  };

  services.displayManager.sddm.enable = true;

  programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
  programs.hyprland = {
    # or wayland.windowManager.hyprland
    enable = false;
    xwayland.enable = true;
  };

  services.gvfs.enable = true;

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';

  services.printing.enable = false;

  # Enable sound.
  hardware.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };
  services.fwupd.enable = true;
  services.dnsmasq = {
    enable = true;
    settings.server = [
      "8.8.8.8"
      "8.8.4.4"
    ];
  };
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
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
    extraGroups = [ "wheel" "networkmanager" "docker" "video" ];
  };
  programs.zsh.enable = true;
  programs.dconf.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  services.blueman.enable = true;
  services.throttled.enable = false;

  environment.systemPackages = with pkgs; [
    git
    home-manager
    wget
    networkmanager
    sddm
    docker
  ];

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

