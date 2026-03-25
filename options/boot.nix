{pkgs, ...}: {
  boot = {
    initrd = {
      verbose = false;
      kernelModules = ["amdgpu"];
    };
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;
    # kernelPackages = pkgs.linuxPackages_latest;
    # kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernel.sysctl = {
      "kernel.sysrq" = 1;
    };
    kernelParams = [
      "mitigations=off"
      "nowatchdog"
      "nmi_watchdog=0"
      "amd_pstate=active"
    ];
    tmp = {
      cleanOnBoot = true;
      useTmpfs = true;
    };
    consoleLogLevel = 2;
    loader = {
      timeout = 5;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        devices = ["nodev"];
        efiSupport = true;
        useOSProber = true;
      };
    };
  };
}
