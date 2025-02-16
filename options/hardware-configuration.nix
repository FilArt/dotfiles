{ lib
, modulesPath
, ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/373cf0d1-d08c-4fdc-93af-33b6e0c7f2c0";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/3F09-D6A9";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

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

    "/home/art/mnt/ssd" = {
      device = "/dev/disk/by-uuid/60F220E9F220C55E";
      fsType = "ntfs";
    };
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  zramSwap.enable = true;
  hardware = {
    cpu.amd.updateMicrocode = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    xpadneo.enable = true;
  };
}
