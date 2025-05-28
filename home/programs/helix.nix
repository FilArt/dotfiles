{
  pkgs,
  lib,
  ...
}: {
  programs.helix = {
    enable = true;

    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = lib.getExe pkgs.alejandra;
        }
        {
          name = "python";
          language-servers = [
            "python"
          ];
        }
      ];

      language-server.python = {
        command = lib.getExe pkgs.python3Packages.python-lsp-server;
      };
    };

    settings = {
      keys.normal = {
        C-g = [":write-all" ":new" ":insert-output lazygit" ":buffer-close!" ":redraw" ":reload-all"];
      };
    };
  };
}
