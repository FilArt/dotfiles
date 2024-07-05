{ config, pkgs, ... }:

let
  py3 = "${pkgs.python3}/bin/python";
in
{
  home.packages = with pkgs; [
    python3
    bfcal
    hicolor-icon-theme
    gnome-icon-theme
  ];
  home.activation.createQtileConfigDir = ''mkdir -p $HOME/.config/qtile'';
  home.file.".config/qtile/config.py".source = config.lib.file.mkOutOfStoreSymlink ./config.py;

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
}
