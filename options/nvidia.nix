{ config, lib, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    prime = {
      sync.enable = true;
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:10:0:0";
    };
  };
}
