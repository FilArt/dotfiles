{pkgs, ...}: {
  home.packages = with pkgs; [
    wf-recorder
    cliphist
    wl-clipboard
    grim
    swappy
    slurp
    pamixer
    rofi-unwrapped
    wlr-randr
    satty
  ];

  home.file.".config/rofi/config.rasi".text = ''
    configuration {
      modi: "clipboard:cliphist list,drun";
      show-modi: "clipboard";
      font: "RobotoMono Nerd Font 11";
      lines: 15;
      columns: 2;
      width: 50;
      show-icons: true;
    }

    @import "${pkgs.rofi-unwrapped}/share/rofi/themes/Adapta-Nokto.rasi"
  '';
}
