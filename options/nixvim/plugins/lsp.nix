{
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      servers = {
        ts_ls.enable = true; # TS/JS
        cssls.enable = true; # CSS
        html.enable = true; # HTML
        #vuels.enable = true; # Vue
        pyright.enable = true;
        marksman.enable = true; # Markdown
        nil_ls.enable = true; # Nix
        nil_ls.settings.formatting.command = ["alejandra"];
        dockerls.enable = true; # Docker
        bashls.enable = true; # Bash
        yamlls.enable = true; # YAML
        ruff.enable = true;
      };

      inlayHints = true;
      keymaps = {
        diagnostic = {
          "<leader>q" = {
            #mode = "n";
            action = "setloclist";
            desc = "Open diagnostic [Q]uickfix list";
          };
        };

        extra = [
          # Jump to the definition of the word under your cusor.
          #  This is where a variable was first declared, or where a function is defined, etc.
          #  To jump back, press <C-t>.
          {
            mode = "n";
            key = "gd";
            action.__raw = "require('telescope.builtin').lsp_definitions";
            options = {desc = "goto definition";};
          }
          # Find references for the word under your cursor.
          {
            mode = "n";
            key = "gr";
            action.__raw = "require('telescope.builtin').lsp_references";
            options = {desc = "goto refs";};
          }
          {
            mode = "n";
            key = "gds";
            action.__raw = "require('telescope.builtin').lsp_document_symbols";
            options = {desc = "LSP: [D]ocument [S]ymbols";};
          }
          {
            mode = "n";
            key = "gws";
            action.__raw = "require('telescope.builtin').lsp_dynamic_workspace_symbols";
            options = {desc = "LSP: [W]orkspace [S]ymbols";};
          }
        ];

        lspBuf = {
          gD = "references";
          ge = "declaration";
          gd = "definition";
          gi = "implementation";
          gt = "type_definition";
          gn = "rename";
          ga = "code_action";
        };
      };
    };

    lsp-format = {
      enable = true;
      autoLoad = true;
    };
  };
}
