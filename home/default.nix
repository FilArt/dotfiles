{ ... }: {
  imports = [
    ./fonts.nix
    ./systemd.nix
    ./xdg.nix
    ./desktop/default.nix
  ]
  ++ import ./programs;
}
