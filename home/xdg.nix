{ config, pkgs, ... }:
let
  gamesDir = "${config.home.homeDirectory}/Games";
  runner = "${gamesDir}/runner.sh";
  steam-run = "${pkgs.steam}/bin/steam-run";
  gamemoderun = "${pkgs.steam}/bin/gamemoderun";
  gamescope = "${pkgs.steam}/bin/gamescope";
  launchArgs = "${steam-run} ${gamemoderun} ${gamescope} --prefer-output HDMI-A-1 --output-width 1920 --output-height 1080 	--nested-width 1920 --nested-height 1080 	--adaptive-sync 	 ${@}";
in
{
  xdg.enable = true;
  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;

  xdg.desktopEntries = {
    tw_wh2 = {
      name = "Total War: Warhammer 2";
      exec = "env -u SDL_VIDEODRIVER ${runner} ${gamesDir}/total-war-warhammer-2/game/start.sh";
      terminal = false;
      type = "Application";
      categories = [ "Game" ];
    };
    hoi4 = {
      name = "Hearts Of IronIV";
      exec = "${runner} ${gamesDir}/HeartsOfIronIV/start.sh";
      icon = "${gamesDir}/HeartsOfIronIV/game/assets/game-logo.png";
      terminal = false;
      type = "Application";
      categories = [ "Game" ];
    };
    ck3 = {
      name = "Crusader Kings III";
      exec = "${runner} ${gamesDir}/ck3/gg/launcher/dowser";
      icon = "${gamesDir}/ck3/gg/launcher/assets/logo.svg";
      terminal = false;
      type = "Application";
      categories = [ "Game" ];
    };
    vic3 = {
      name = "Victoria 3";
      exec = "${runner} ${gamesDir}/Victoria3/Victoria 3/start";
      icon = "${gamesDir}/Victoria3/Victoria 3/game/icon.png";
      terminal = false;
      type = "Application";
      categories = [ "Game" ];
    };
  };
}
