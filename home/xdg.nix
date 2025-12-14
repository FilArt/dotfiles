{
  config,
  pkgs,
  ...
}: let
  homeDir = config.home.homeDirectory;
  gamesDir = "${homeDir}/Games";
  steam-run = "${pkgs.steam-run}/bin/steam-run";
  gamemoderun = "${pkgs.gamemode}/bin/gamemoderun";
  gamescope = "${pkgs.gamescope}/bin/gamescope";
  qhd = ''--output-width "3840" --output-height "2160" --nested-width "3840" --nested-height "2160"'';
  fullHD = ''--output-width "1920" --output-height "1080" --nested-width "1920" --nested-height "1080"'';
  runGame = ''${steam-run} ${gamemoderun} ${gamescope} ${qhd} --adaptive-sync --hdr-enabled --rt --steam'';
in {
  xdg.enable = true;
  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;
}
