{pkgs, ...}: let
  oldGamescope = pkgs.gamescope.overrideAttrs (final: prev: {
    version = "3.12.0";
  });
in {
  programs = {
    gamescope = {
      enable = true;
      package = oldGamescope;
    };
    steam = {
      enable = true;
      gamescopeSession = {
        enable = true;
      };
    };
    gamemode.enable = true;

    zsh.enable = true;
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    nh = {
      enable = true;
      clean.enable = false;
      flake = "/home/art/.config/home-manager";
    };

    kdeconnect.enable = true;
  };
}
