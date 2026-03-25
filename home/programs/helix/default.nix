{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  helixUtils = "${config.xdg.configHome}/helix/utils";
in {
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.default;
    extraPackages = [
      pkgs.basedpyright
      pkgs.wl-clipboard
      pkgs.typescript-language-server
    ];

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
            "basedpyright"
          ];
          auto-format = true;
          formatter.command = lib.getExe pkgs.ruff;
          formatter.args = ["format" "-"];
        }
        {
          name = "vue";
          language-servers = [
            "vuels"
          ];
          scope = "source.vue";
          injection-regex = "vue";
          file-types = ["vue"];
          roots = ["package.json"];
          block-comment-tokens = {
            start = "<!--";
            end = "-->";
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }
      ];

      language-server = {
        python = {
          command = lib.getExe pkgs.basedpyright;
        };

        vuels = {
          command = lib.getExe pkgs.vue-language-server;
        };
      };
    };

    settings = {
      editor = {
        clipboard-provider = "wayland";
      };

      keys.normal = {
        A-g = [":write-all" ":new" ":insert-output lazygit" ":buffer-close!" ":redraw" ":reload-all"];
        A-s = [":w"];

        A-j = ["extend_to_line_bounds" "delete_selection" "paste_after"];
        A-k = ["extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before"];

        A-w = [":bc"];

        space.g = {
          f = "changed_file_picker";
          r = ":reset-diff-change";
          b = ":run-shell-command ${helixUtils}/blame_line_pretty.sh %{buffer_name} %{cursor_line}";
          B = ":open %sh{${helixUtils}/blame_file_pretty.sh %{buffer_name} %{cursor_line}}";
          h = ":run-shell-command ${helixUtils}/git-hunk.sh %{buffer_name} %{cursor_line} 3";
        };

        space.l = {
          e = [
            ":sh bun run eslint %{buffer_name} --fix"
            ":rl"
          ];
        };
      };
    };
  };

  xdg.configFile = {
    "helix/utils/blame_file_pretty.sh" = {
      source = ./utils/blame_file_pretty.sh;
      executable = true;
    };

    "helix/utils/blame_line_pretty.sh" = {
      source = ./utils/blame_line_pretty.sh;
      executable = true;
    };

    "helix/utils/git-hunk.sh" = {
      source = ./utils/git-hunk.sh;
      executable = true;
    };
  };
}
