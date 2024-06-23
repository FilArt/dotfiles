{ pkgs, ... }: {
  qt = {
    enable = true;
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
    platformTheme.name = "adwaita";
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
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
    #name = "Vanilla-DMZ";
    #package = pkgs.vanilla-dmz;
  };
}
