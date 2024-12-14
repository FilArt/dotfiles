{ config, pkgs, ... }:
let
  mountPath = "${config.home.homeDirectory}/mnt";
  rcloneParams = "--vfs-cache-mode=writes --vfs-cache-max-age=12h";
  createMountService = name: remote: {
    Unit = {
      After = [ "network-online.target" ];
      Description = "RClone Mount ${name}";
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${mountPath}/${name}";
      ExecStart = "${pkgs.rclone}/bin/rclone mount ${rcloneParams} ${remote}: ${mountPath}/${name}";
      ExecStop = "fusermount -u ${mountPath}/${name}";
      Restart = "always";
      RestartSec = "10s";
      Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
    };
  };
in
{
  systemd.user.services.gdrive_mount = createMountService "gdrive" "gdrive";
  systemd.user.services.onedrive_mount = createMountService "onedrive" "onedrive";
}
