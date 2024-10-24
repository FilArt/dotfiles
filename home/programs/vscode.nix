{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    enableUpdateCheck = false;
    extensions = with pkgs.vscode-extensions; [
      ms-vscode-remote.remote-containers
      ms-python.python
      charliermarsh.ruff
      jnoortheen.nix-ide
      pkief.material-icon-theme
      ms-python.debugpy
      ms-python.vscode-pylance
    ];
    userSettings = {
      "editor.fontFamily" = "RobotoMono Nerd Font";
      "editor.formatOnSave" = true;
      "[python]" = {
        "editor.formatOnSave" = true;
        "editor.defaultFormatter" = "charliermarsh.ruff";
        "editor.codeActionsOnSave" = {
          "source.fixAll" = "explicit";
          "source.organizeImports" = "explicit";
        };
      };
      "codeium.enableConfig" = {
        "*" = true;
        "nix" = true;
      };
      "git.confirmSync" = false;
    };
  };

  home.file.".config/home-manager/.vscode/settings.json".text = ''
    {
      "editor.fontFamily": "'RobotoMono Nerd Font', 'Font Awesome 6 Free', 'Material Design Icons'",
      "python.analysis.extraPaths": [
              ]
    }
  '';
}
