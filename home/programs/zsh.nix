{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    oh-my-zsh.enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 100000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    shellAliases = {
      switch = "nh os switch -H art /home/art/.config/home-manager";
      df = lib.getExe pkgs.duf;
      duf = lib.getExe pkgs.duf;
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
      hostname.disabled = true;
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
