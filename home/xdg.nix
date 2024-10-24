{ config, ... }:
let
  gamesDir = "${config.home.homeDirectory}/Games";
  runner = "${gamesDir}/runner.sh";
in
{
  xdg.enable = true;
  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;

  xdg.desktopEntries.hoi4 = {
    name = "Hearts Of IronIV";
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
  xdg.desktopEntries.vic3 = {
    name = "Victoria 3";
    exec = "${runner} ${gamesDir}/Victoria3/Victoria 3/start";
    icon = "${gamesDir}/Victoria3/Victoria 3/game/icon.png";
    terminal = false;
    type = "Application";
    categories = [ "Game" ];
  };
}
