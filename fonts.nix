{ pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "joypixels"
    ];
  nixpkgs.config.joypixels.acceptLicense = true;

  home.packages = with pkgs; [
    open-sans
    cascadia-code
    liberation_ttf
    font-awesome
    openmoji-color
  ];

  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.emoji = [ "JoyPixels" ];

  gtk.font = {
    name = "OpenSans";
    size = 11;
  };

}
