{ config, lib, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    prime = {
      sync.enable = true;
      amdgpuBusId = "PCI:10:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
