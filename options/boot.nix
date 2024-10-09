{ pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };
  boot.kernelParams = [
    "mitigations=off"
    "nowatchdog"
    "nmi_watchdog=0"
    "usbcore.autosuspend=120" # 2 minutes
  ];
  boot.blacklistedKernelModules = [ "iTCO_wdt" "rtw88_8822bu" ];
  boot.extraModulePackages = with pkgs.linuxPackages_latest; [ rtl88x2bu ];
  boot.tmp.cleanOnBoot = true;
  boot.tmp.useTmpfs = true;
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
    };
  };
  time.hardwareClockInLocalTime = true;
}
