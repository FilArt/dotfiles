{ config, ... }:
let
  gamesDir = "${config.home.homeDirectory}/mnt/hdd/Games";
  runner = "${gamesDir}/runner.sh";
in
{
  xdg.enable = true;
  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;

  xdg.desktopEntries.hoi4 = {
    name = "HeartsOfIronIV";
    exec = "${runner} ${gamesDir}/HeartsOfIronIV/start.sh";
    icon = "${gamesDir}/HeartsOfIronIV/game/assets/game-logo.png";
    terminal = false;
    type = "Application";
    categories = [ "Game" ];
  };
  xdg.desktopEntries.ck3 = {
    name = "Crusader Kings III";
    exec = "${runner} ${gamesDir}/ck3/gg/launcher/dowser";
    icon = "${gamesDir}/ck3/gg/launcher/assets/logo.svg";
    terminal = false;
    type = "Application";
    categories = [ "Game" ];
  };
}
