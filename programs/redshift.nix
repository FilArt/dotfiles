{ pkgs, ... }: {
  home.packages = [ pkgs.redshift ];
  services.redshift.enable = true;
  services.redshift.provider = "geoclue2";
}
