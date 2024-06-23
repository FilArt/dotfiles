{ pkgs, ... }: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "''${pkgs.foot}/bin/foot";
        layer = "overlay";
      };
      colors.background = "1D1011ff";
      colors.text = "F7DCDEff";
      colors.selection = "574144ff";
      colors.selection-text = "DEBFC2ff";
      colors.border = "574144dd";
      colors.match = "FFB2BCff";
      colors.selection-match = "FFB2BCff";
    };
  };
}
