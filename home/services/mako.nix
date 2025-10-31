{pkgs, ...}: {
  services.mako = {
    enable = true;
    settings = {
      on-notify = "exec ${pkgs.mpv}/bin/mpv --volume=50 $HOME/Music/noty.wav";
    };
  };
}
