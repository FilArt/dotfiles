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
      pkgs.bash-language-server
      pkgs.basedpyright
      pkgs.markdown-oxide
      pkgs.nil
      pkgs.shfmt
      pkgs.taplo
      pkgs.vscode-langservers-extracted
      pkgs.yaml-language-server
      pkgs.wl-clipboard
      pkgs.typescript-language-server
    ];

    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = lib.getExe pkgs.alejandra;
          language-servers = [
            "nil"
          ];
        }
        {
          name = "json";
          language-servers = [
            "vscode-json-language-server"
          ];
        }
        {
          name = "toml";
          language-servers = [
            "taplo"
          ];
        }
        {
          name = "yaml";
          language-servers = [
            "yaml-language-server"
          ];
        }
        {
          name = "markdown";
          language-servers = [
            "markdown-oxide"
          ];
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
          name = "bash";
          language-servers = [
            "bash-language-server"
          ];
          auto-format = true;
          formatter.command = lib.getExe pkgs.shfmt;
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
        "bash-language-server" = {
          command = lib.getExe pkgs.bash-language-server;
          args = [
            "start"
          ];
        };

        nil = {
          command = lib.getExe pkgs.nil;
        };

        python = {
          command = lib.getExe pkgs.basedpyright;
        };

        "vscode-json-language-server" = {
          command = lib.getExe' pkgs.vscode-langservers-extracted "vscode-json-language-server";
          args = [
            "--stdio"
            "--only"
            "json"
          ];
        };

        "yaml-language-server" = {
          command = lib.getExe pkgs.yaml-language-server;
          args = [
            "--stdio"
          ];
        };

        "markdown-oxide" = {
          command = lib.getExe pkgs.markdown-oxide;
        };

        taplo = {
          command = lib.getExe pkgs.taplo;
          args = [
            "lsp"
            "stdio"
          ];
        };

        vuels = {
          command = lib.getExe pkgs.vue-language-server;
        };
      };
    };

    settings = {
      editor = {
        auto-pairs = true;
        bufferline = "multiple";
        clipboard-provider = "wayland";
        cursorline = true;
        end-of-line-diagnostics = "hint";
        gutters = [
          "diagnostics"
          "spacer"
          "line-numbers"
          "spacer"
          "diff"
        ];
        line-number = "relative";
        rulers = [
          80
          100
        ];
        soft-wrap = {
          enable = true;
        };
        indent-guides = {
          render = true;
        };
        lsp = {
          display-inlay-hints = true;
          auto-signature-help = true;
        };
      };

      keys.normal = {
        A-g = [":write-all" ":new" ":insert-output lazygit" ":buffer-close!" ":redraw" ":reload-all"];
        A-s = [":w"];

        A-j = ["extend_to_line_bounds" "delete_selection" "paste_after"];
        A-k = ["extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before"];

        A-w = [":bc"];

        space = {
          f = "file_picker";
          F = "file_picker_in_current_directory";
          b = "buffer_picker";
          s = "lsp_or_syntax_symbol_picker";
          S = "lsp_or_syntax_workspace_symbol_picker";
          d = "diagnostics_picker";
          D = "workspace_diagnostics_picker";
          a = "code_action";
          r = "rename_symbol";
          k = "hover";
          "/" = "global_search";
        };

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
