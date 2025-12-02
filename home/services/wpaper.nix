{config, ...}: {
  services.wpaperd = {
    enable = true;
    settings = {
      default = {
        duration = "30m";
        mode = "center";
        sorting = "ascending";
        path = "${config.home.homeDirectory}/Pictures/wallpapers";
      };
    };
  };
}
