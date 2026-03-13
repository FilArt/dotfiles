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
    archie-switch = "nh os switch . -H archie --target-host archie";
    df = lib.getExe pkgs.duf;
    duf = lib.getExe pkgs.duf;
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
