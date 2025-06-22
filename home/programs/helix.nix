{
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.default;

    extraPackages = [
      pkgs.basedpyright
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
      keys.normal = {
        A-g = [":write-all" ":new" ":insert-output lazygit" ":buffer-close!" ":redraw" ":reload-all"];
        A-s = [":w"];

        A-j = ["extend_to_line_bounds" "delete_selection" "paste_after"];
        A-k = ["extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before"];

        A-w = [":bc"];

        space.l = {
          e = [
            ":sh bun run eslint %{buffer_name} --fix"
            ":rl"
          ];
        };
      };
    };
  };
}
