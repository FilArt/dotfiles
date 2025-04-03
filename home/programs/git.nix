{
  programs.git = {
    enable = true;
    userName = "FilArt";
    userEmail = "filart97@gmail.com";
    aliases = {
      ci = "commit";
      co = "checkout";
      s = "status";
    };
    includes = [
      {
        condition = "gitdir:~/roi/";
        contents = {
          user = {
            name = "Artur Filimonov";
            email = "artur.filimonov@plexus.es";
          };
        };
      }
    ];
    extraConfig = {
      init.defaultBranch = "main";
      fetch.prune = true;
      rerere = {
        enabled = true;
        autoUpdate = true;
      };
    };

    signing = {
      signByDefault = true;
    };
  };
}
