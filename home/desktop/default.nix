{ ... }: {
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
}
