{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.roboto-mono
    nerd-fonts.jetbrains-mono
    inter-nerdfont
    font-awesome
    material-design-icons
    source-han-sans
    source-han-sans-japanese
    source-han-serif-japanese
    roboto
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
