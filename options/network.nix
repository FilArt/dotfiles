{
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };

    firewall = {
      enable = false; # pycharm docker debug not working with firewall
      allowPing = false;
      allowedTCPPorts = [42971];
    };
  };
}
