{ ... }: {
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    wireless.enable = false; # disable wpa_supplicant

    firewall = {
      enable = false; # pycharm docker debug not working with firewall
      allowPing = false;
      allowedTCPPorts = [ 42971 ];
    };
  };


}
