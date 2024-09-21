{ pkgs, ... }: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.foot}/bin/foot";
        layer = "overlay";
        dpi-aware = true;
        font = "RobotoMono Nerd Font";
        icon-theme = "Papirus-Dark";
        show-actions = true;
      };
      colors.background = "1e1e2edd";
      colors.text = "cdd6f4ff";
      colors.selection = "585b70ff";
      colors.selection-text = "DEBFC2ff";
      colors.border = "b4befeff";
      colors.match = "f38ba8ff";
      colors.selection-match = "f38ba8ff";
    };
  };
}
