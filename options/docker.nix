{ ... }: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    #storageDriver = "btrfs";
    daemon.settings = {
      userland-proxy = true;
      #data-root = "/home/art/mnt/hdd/.docker_data";
      # data-root = "/home/art/mnt/ssd/Users/filar/.docker_data";
    };
  };
}
