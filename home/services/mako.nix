{pkgs, ...}: {
  services.mako = {
    enable = true;
    settings = {
      on-notify = "exec ${pkgs.mpv}/bin/mpv $HOME/Music/noty.wav";
    };
  };
}
