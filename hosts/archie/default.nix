{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../nix.nix
    ./hardware-configuration.nix
    ./hosting.nix
    ./todoart.nix
  ];

  networking.hostName = "archie";
  time.timeZone = "Europe/Madrid";

  boot.loader.grub.enable = true;
  boot.loader.grub.useOSProber = false;

  disko.devices = {
    disk.main = {
      device = "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          grub = {
            size = "1M";
            type = "EF02";
          };
          boot = {
            size = "512M";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/boot";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };

  networking.useNetworkd = true;
  systemd.network.enable = true;
  systemd.network.networks."10-wan" = {
    matchConfig.Name = "en*";
    networkConfig.DHCP = "ipv4";
    linkConfig.RequiredForOnline = "routable";
  };

  users.users.archie = {
    isNormalUser = true;
    description = "archie";
    shell = pkgs.zsh;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMzVVzsenw3KXCnFseabHTwTnJE66S9i/XNmRGcbVAtq archie"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    ports = [6022];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = ["archie"];
      X11Forwarding = false;
      MaxAuthTries = 3;
      LoginGraceTime = 30;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
    };
  };

  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [6022];
    logRefusedConnections = false;
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";
    jails.sshd.settings = {
      enabled = true;
      backend = "systemd";
      findtime = "10m";
      port = "6022";
    };
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    git
    helix
    htop
    tmux
  ];

  archie.todoart = {
    enable = true;
    domain = "todo-api.artfil.site";
    environmentFile = "/var/lib/secrets/todoart-api.env";
  };

  system.stateVersion = "25.11";
}
