{
  config,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
    };
  };
  home.file = {
    ".config/waybar/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/home/desktop/waybar/config.jsonc";
    ".config/waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/home/desktop/waybar/style.css";
    ".local/bin/launch_waybar.sh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/home/desktop/scripts/launch_waybar.sh";
  };

  home.packages = with pkgs; [
    inotify-tools
  ];
}
