{
  imports =
    [
      ./systemd.nix
      ./xdg.nix
      ./desktop/default.nix
      ./services/default.nix
    ]
    ++ import ./programs;
}
