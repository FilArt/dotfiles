{ ... }: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    storageDriver = "btrfs";
    daemon.settings = {
      userland-proxy = false;
      data-root = "/home/art/mnt/hdd/.docker_data";
    };
  };
}
