{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "RobotoMono" ]; })
    font-awesome
    material-design-icons
    source-han-sans
    source-han-sans-japanese
    source-han-serif-japanese
    roboto
    roboto-mono
    roboto-serif
    openmoji-color
  ];
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Roboto Serif" "Liberation Serif" "DejaVu Serif" "Noto Serif" ];
        sansSerif = [ "Roboto" "Libration Sans" "DejaVu Sans" "Noto Sans" ];
        monospace = [ "RobotoMono" ];
        emoji = [ "OpenMoji Color" "JoyPixels" "Noto Color Emoji" ];
      };
    };
  };
  gtk.font = {
    name = "Roboto";
    size = 11;
  };
}
