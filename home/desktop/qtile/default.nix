{ config, pkgs, ... }:

let
  py3 = "${pkgs.python3}/bin/python";
in
{
  home.packages = with pkgs; [
    python3
    hicolor-icon-theme
    gnome-icon-theme
    gsimplecal
    playerctl
    dunst
  ];
  home.file.".config/qtile".source = config.lib.file.mkOutOfStoreSymlink ./config;

  home.file.".config/swappy/config".text = ''
    [Default]
    save_dir=$HOME/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=false
    line_size=5
    text_size=20
    text_font=sans-serif
    paint_mode=brush
    early_exit=false
    fill_shape=false
  '';

  home.file.".config/gsimplecal/config".text = ''
    show_calendar = 1
    show_timezones = 1
    mark_today = 1
    show_week_numbers = 0
    close_on_unfocus = 0
    close_on_mouseleave = 0
    clock_format = %d/%m %a %H:%M
    force_lang = ru_RU.utf8
    clock_label = Мадрид
    clock_tz =
    clock_label = Санкт-Петербург
    clock_tz = :Europe/Moscow
    clock_label = UTC
    clock_tz = :UTC
  '';
}
