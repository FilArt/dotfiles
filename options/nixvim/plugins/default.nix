{pkgs, ...}: {
  imports = [
    ./lsp.nix
  ];
  programs.nixvim.nixpkgs.config.allowUnfree = true;

  programs.nixvim.extraPlugins = with pkgs; [
    vimPlugins.nvim-pqf
  ];

  programs.nixvim.autoCmd = [
    {
      # Disable cmp in neorepl
      event = ["FileType"];
      pattern = "neorepl";
      callback.__raw = ''
        function()
          require("cmp").setup.buffer { enabled = false }
        end
      '';
    }
  ];

  programs.nixvim.editorconfig.enable = true;

  programs.nixvim.plugins = {
    avante.enable = true;
    avante.settings.provider = "copilot";
    avante.settings.auto_suggestions_provider = "copilot";
    project-nvim.enable = true;
    notify.enable = true;
    barbar.enable = true;
    mini.enable = true;
    mini.modules.move = {
      mappings = {
        left = "<A-h>";
        right = "<A-l>";
        down = "<A-j>";
        up = "<A-k>";

        line_left = "<A-h>";
        line_right = "<A-l";
        line_down = "<A-j>";
        line_up = "<A-k>";
      };
    };

    auto-session.enable = true;

    direnv.enable = true;
    direnv.settings.direnv_silent_load = 0;
    nvim-autopairs.enable = true;

    codeium-nvim.enable = true;
    codeium-nvim.settings = {
      virtual_text = {
        enabled = true;
      };
    };

    fidget = {enable = true;};
    cmp-nvim-lsp = {enable = true;};

    telescope = {
      enable = true;
      extensions = {
        fzf-native = {
          enable = true;
        };
      };
    };

    cmp.enable = true;
    cmp.settings.mapping = {
      "<C-Space>" = "cmp.mapping.complete()";
      "<C-d>" = "cmp.mapping.scroll_docs(-4)";
      "<C-e>" = "cmp.mapping.close()";
      "<C-f>" = "cmp.mapping.scroll_docs(4)";
      "<CR>" = "cmp.mapping.confirm({ select = true })";
      "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
      "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
    };

    cmp.settings.sources = [
      {name = "codeium";}
      {name = "buffer";}
      {name = "nvim_lsp";}
      {name = "path";}
      {name = "luasnip";}
    ];
    conform-nvim = {
      enable = true;
      settings = {
        notify_on_error = true;
        formatters_by_ft = {
          html = ["prettierd" "prettier"];
          css = ["prettierd" "prettier"];
          javascript = ["prettierd" "prettier"];
          typescript = ["prettierd" "prettier"];
          markdown = ["prettierd" "prettier"];
          python = ["ruff"];
          nix = ["alejandra"];
          bash = ["shfmt" "beautysh"];
          sh = ["shellcheck" "beautysh"];
          yaml = ["yamllint" "yamlfmt"];
          json = ["fixjson"];
          "_" = [
            "trim_whitespace"
            "trim_newlines"
          ];
        };
      };
    };

    # none-ls = {
    #  enable = true;
    #  settings = {
    #    cmd = ["bash -c nvim"];
    #    debug = true;
    #  };
    #  sources = {
    #    code_actions = {
    #      statix.enable = true;
    #      gitsigns.enable = true;
    #    };
    #    diagnostics = {
    #      statix.enable = true;
    #      deadnix.enable = true;
    #      pylint.enable = true;
    #      checkstyle.enable = true;
    #      mypy.enable = true;
    #    };
    #    formatting = {
    #      alejandra.enable = true;
    #      shfmt.enable = true;
    #      prettier = {
    #        enable = true;
    #        disableTsServerFormatter = true;
    #      };
    #    };
    #    completion = {
    #      spell.enable = true;
    #    };
    #  };
    # };

    dap.configurations = {
      manage = [
        {
          name = "Debug Django";
          type = "python";
          request = "launch";
          program = ''''${workspaceFolder}/.venv/bin/python manage.py'';
        }
      ];
    };
    dap-python.enable = true;
    dap-ui.enable = true;
    dap-ui.luaConfig.post = ''
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    '';
    smart-splits.enable = true;
    undotree.enable = true;
    which-key.enable = true;
    which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>aa";
        __unkeyed-2 = "<cmd>AvanteAsk<cr>";
        icon = "  ";
        desc = "Open AI Ask";
      }

      {
        __unkeyed-1 = "<leader>ac";
        __unkeyed-2 = "<cmd>AvanteChat<cr>";
        icon = "  ";
        desc = "Open AI Chat";
      }

      {
        __unkeyed-1 = "<leader>ae";
        __unkeyed-2 = "<cmd>AvanteEdit<cr>";
        icon = "  ";
        desc = "Edit with instruction";
      }
    ];
    lastplace.enable = true;
    lazygit.enable = true;
    web-devicons.enable = true;
    bufferline.enable = true;
    lualine.enable = true;
    lualine.settings.sections.lualine_c = [
      {
        __unkeyed-1 = "filename";
        path = 3;
      }
    ];
    treesitter.enable = true;

    neo-tree.enable = true;
    neo-tree.hideRootNode = true;

    lint = {
      enable = true;
      lintersByFt = {
        text = ["vale"];
        json = ["jsonlint"];
        markdown = ["vale"];
        dockerfile = ["hadolint"];
        python = ["ruff"];
      };
    };

    gitsigns = {
      enable = true;
      settings.current_line_blame = true;
    };

    # noice.enable = true;
    nui.enable = true;

    commentary.enable = true;
  };
}
