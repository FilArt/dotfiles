{pkgs, ...}: {
  boot = {
    loader.timeout = 15;
    initrd = {
      verbose = false;
      availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "uas" "sd_mod"];
      kernelModules = ["amdgpu"];
    };
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernel.sysctl = {
      "kernel.sysrq" = 1;
    };
    kernelParams = [
      "mitigations=off"
      "nowatchdog"
      "nmi_watchdog=0"
      "usbcore.autosuspend=120" # 2 minutes
      "amd_pstate=passive"
    ];
    # blacklistedKernelModules = ["iTCO_wdt" "rtw88_8822bu"];
    # kernelModules = ["88x2bu"];
    # extraModulePackages = [pkgs.linuxKernel.packages.linux_zen.rtl88x2bu];
    # extraModprobeConfig = ''
    #   options 88x2bu rtw_switch_usb_mode=1
    # '';
    tmp = {
      cleanOnBoot = true;
      useTmpfs = true;
    };
    consoleLogLevel = 3;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        devices = ["nodev"];
        efiSupport = true;
        useOSProber = true;
      };
    };
  };
  time.hardwareClockInLocalTime = true;
}
