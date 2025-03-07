{config, ...}: {
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "wayland-session@niri-uwsm.desktop.target";
    };
  };
  home.file.".config/waybar/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/home/desktop/waybar/config.jsonc";
  # home.file.".config/waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/home/desktop/waybar/style.css";
}
