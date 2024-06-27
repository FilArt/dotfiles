{ pkgs, ... }: {
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    #cursorTheme = {
    #  name = "Vanilla-DMZ";
    #  package = pkgs.vanilla-dmz;
    #};
  };

  home.sessionVariables.GTK_THEME = "Adwaita:dark";
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "Bibata-Modern-Classic";
    };
  };
}
