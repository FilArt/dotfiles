{ pkgs, ... }:

let
  # Переопределяем gamescope с нужными параметрами
  gamescope = pkgs.gamescope.overrideAttrs (oldAttrs: {
    version = "3.14.24"; # Укажи версию, которую хочешь использовать
    src = pkgs.fetchFromGitHub {
      owner = "ValveSoftware";
      repo = "gamescope";
      rev = "cf2497fd7ec83f3d0dd5cb31b69540a2d129edad"; # Тег с нужной версией
      sha256 = "sha256-+8uojnfx8V8BiYAeUsOaXTXrlcST83z6Eld7qv1oboE="; # Укажи правильный хэш
      fetchSubmodules = true;
    };
  });
in
{
  programs.gamescope.enable = true;
  programs.gamescope.package = gamescope;
}
