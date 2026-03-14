{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./zsh-shared.nix
  ];

  programs.zsh.shellAliases = {
    switch = "nh os switch";
    archie-switch = "nh os switch ~/.config/home-manager -H archie --target-host archie";
    df = lib.getExe pkgs.duf;
    duf = lib.getExe pkgs.duf;
  };
}
