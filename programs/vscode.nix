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
    ]
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "codeium";
        publisher = "codeium";
        version = "1.9.71";
        sha256 = "fcaa24610a9b4ec4e9d6648e1d07821de203184a63d712f647ec81b048e72fda";
      }
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
      "codeium.enableConfig" = {
        "*" = true;
        "nix" = true;
      };
    };
  };
}
