{
  ...
}: {
  imports = [
    ../../home/programs/zsh-shared.nix
  ];

  programs.home-manager.enable = true;

  home = {
    username = "archie";
    homeDirectory = "/home/archie";
    stateVersion = "25.11";
  };

  xdg.enable = true;
}
