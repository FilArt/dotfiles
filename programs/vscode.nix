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
    ]
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "codeium";
        publisher = "codeium";
        version = "1.9.84";
        sha256 = "f62b5c73d1f50e98d49ed66488d6c959f1f447c5a74789ac6b93f2465fdaf673";
      }
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
    };
  };
}
