{pkgs, ...}: {
  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscode.fhs;
  programs.vscode.profiles.default = {
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
      "[css]" = {
        "editor.defaultFormatter" = "vscode.css-language-features";
      };
      "[shellscript]" = {
        "editor.defaultFormatter" = "mads-hartmann.bash-ide-vscode";
      };
      "nix.formatterPath" = "alejandra";
    };
  };
}
