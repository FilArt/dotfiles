{ pkgs, ... }:

{
  home.packages = [ pkgs.ianny ];
  xdg.configFile."io.github.zefr0x.ianny/config.toml".source = ./config.toml;
}

