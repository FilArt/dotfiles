{ ... }: {
  services = {
    blueman.enable = true;
    dnsmasq = {
      enable = true;
      settings.server = [
        "8.8.8.8"
        "8.8.4.4"
      ];
    };
    fstrim.enable = true;
    fwupd.enable = true;
    gvfs.enable = true;
    power-profiles-daemon.enable = true;
    printing.enable = false;
    upower.enable = true;
  };
}
