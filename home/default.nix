{ ... }: {
  imports = [
    ./fonts.nix
    ./systemd.nix
    ./xdg.nix
  ]
  ++ import ./desktop
  ++ import ./programs;
}
