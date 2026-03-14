{config, ...}: {
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    oh-my-zsh.enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 100000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      username = {
        style_user = "blue bold";
        style_root = "red bold";
        format = "[$user]($style) ";
        disabled = false;
        show_always = true;
      };
      add_newline = true;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = false;
      scan_timeout = 10;
      command_timeout = 100;
      dotnet.disabled = true;
      nodejs.disabled = true;
      package.disabled = true;
    };
  };
}
