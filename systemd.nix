{ pkgs, ... }: {
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  systemd.user.services.gdrive_mount = {
    Unit = {
      After = [ "network-online.target" ];
      Description = "RClone Mount Google Drive";
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStartPre = "/run/wrappers/bin/umount /home/art/mnt/gdrive && /run/wrappers/bin/mkdir -p /home/art/mnt/gdrive";
      ExecStart = "${pkgs.rclone}/bin/rclone mount --vfs-cache-mode=writes --vfs-cache-max-age=12h gdrive: /home/art/mnt/gdrive";
      ExecStop = "/run/wrappers/bin/fusermount -u /home/art/mnt/gdrive";
      Restart = "always";
      RestartSec = "10s";
      Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
    };
  };

  systemd.user.services.onedrive_mount = {
    Unit = {
      After = [ "network-online.target" ];
      Description = "RClone Mount OneDrive";
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStartPre = "/run/wrappers/bin/umount /home/art/mnt/onedrive && /run/wrappers/bin/mkdir -p /home/art/mnt/onedrive";
      ExecStart = "${pkgs.rclone}/bin/rclone mount --vfs-cache-mode=writes --vfs-cache-max-age=12h onedrive: /home/art/mnt/onedrive";
      ExecStop = "/run/wrappers/bin/fusermount -u /home/art/mnt/onedrive";
      Restart = "always";
      RestartSec = "10s";
      Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
    };
  };
}
