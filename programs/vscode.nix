{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
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
        "editor.defaultFormatter" = null;
        "editor.codeActionsOnSave" = {
          "source.fixAll" = "explicit";
        };
      };
    };
  };
}
