{ ... }: {
  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;

    zsh.enable = true;
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
