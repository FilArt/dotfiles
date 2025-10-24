{
  programs.git = {
    enable = true;
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
    settings = {
      user = {
        name = "FilArt";
        email = "filart97@gmail.com";
      };
      aliases = {
        ci = "commit";
        co = "checkout";
        s = "status";
      };
      init.defaultBranch = "main";
      fetch.prune = true;
      rerere = {
        enabled = true;
        autoUpdate = true;
      };
    };
  };
}
