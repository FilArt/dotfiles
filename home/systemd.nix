{ config, pkgs, ... }:
let
  mountPath = "${config.home.homeDirectory}/mnt";
  rcloneParams = "--vfs-cache-mode=writes --vfs-cache-max-age=12h";
in
{
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      After = [ "display-manager.service" ];
      # Requires = [ "graphical-session-pre.target" ];
    };
  };

  systemd.user.services.gdrive_mount = {
    Unit = {
      After = [ "network-online.target" ];
      Description = "RClone Mount Google Drive";
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${pkgs.rclone}/bin/rclone mount ${rcloneParams}  gdrive: ${mountPath}/gdrive";
      ExecStop = "fusermount -u ${mountPath}/gdrive";
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
      ExecStart = "${pkgs.rclone}/bin/rclone mount ${rcloneParams} onedrive: ${mountPath}/onedrive";
      ExecStop = "fusermount -u ${mountPath}/onedrive";
      Restart = "always";
      RestartSec = "10s";
      Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
    };
  };
}
