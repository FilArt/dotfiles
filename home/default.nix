{
  imports =
    [
      ./systemd.nix
      ./xdg.nix
      ./desktop/default.nix
    ]
    ++ import ./programs;
}
