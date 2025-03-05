{ config, ... }: {
  imports = [
    ./hyprland/default.nix
    ./qtile/default.nix
    ./waybar/default.nix
    ./theming.nix
    ./wayland.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
  };



  home.file.".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/home/desktop/niri.kdl";
}
