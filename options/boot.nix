{ pkgs, ... }: {
  boot = {
    initrd = {
      verbose = false;
      availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "uas" "sd_mod" ];
      kernelModules = [ "amdgpu" ];
    };
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;
    kernel.sysctl = {
      "kernel.sysrq" = 1;
    };
    kernelParams = [
      "mitigations=off"
      "nowatchdog"
      "nmi_watchdog=0"
      "usbcore.autosuspend=120" # 2 minutes
      "amd_pstate=active"
    ];
    blacklistedKernelModules = [ "iTCO_wdt" "rtw88_8822bu" ];
    extraModulePackages = with pkgs.linuxKernel.packages.linux_xanmod_stable; [ rtl88x2bu ];
    tmp = {
      cleanOnBoot = true;
      useTmpfs = true;
    };
    consoleLogLevel = 3;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
      };
    };
  };
  time.hardwareClockInLocalTime = true;
}
