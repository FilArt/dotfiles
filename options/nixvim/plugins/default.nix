{pkgs, ...}: {
  imports = [
    ./lsp.nix
  ];
  programs.nixvim.nixpkgs.config.allowUnfree = true;

  programs.nixvim.editorconfig.enable = true;

  programs.nixvim.plugins = {
    auto-session.enable = true;
    autoclose.enable = true;
    cursorline.enable = true;
    # AI
    avante = {
      enable = true;
      settings = {
        provider = "gemini";
        auto_suggestions_provider = "gemini";
        highlights = {
          diff = {
            current = "DiffText";
            incoming = "DiffAdd";
          };
        };
        hints = {
          enabled = true;
        };
      };
    };

    notify.enable = true;
    barbar.enable = true; # tabs
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

    direnv.enable = true;
    direnv.settings.direnv_silent_load = 0;
    nvim-autopairs.enable = true;

    fidget = {enable = true;};
    cmp-nvim-lsp = {enable = true;};

    telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
        file-browser.enable = true;
        frecency.enable = true;
        media-files.enable = true;
        project = {
          enable = true;
          settings = {
            sync_with_nvim_tree = true;
            on_project_selected = {
              __raw = ''
                function(prompt_bufnr)
                   local project_actions = require("telescope._extensions.project.actions")
                   local Path = require('plenary.path')
                   local dap = require("dap")
                   local dap_python = require("dap-python")
                   local actions_state = require("telescope.actions.state")

                   project_actions.change_working_directory(prompt_bufnr, false)

                   -- Check for both .venv and .devenv/state/venv to setup python
                   local project_root = actions_state.get_selected_entry(prompt_bufnr).value
                   local python_path = project_root .. "/.venv/bin/python"
                   if not Path:new(python_path):exists() then
                     python_path = project_root .. "/.devenv/state/venv/bin/python"
                   end
                   if Path:new(python_path):exists() then
                     dap_python.setup(python_path)
                   end

                    vim.lsp.enable("basedpyright")
                    vim.cmd("PyrightSetPythonPath " .. python_path)

                end
              '';
            };
          };
        };
        ui-select.enable = true;
        undo.enable = true;
      };
      settings = {
        file_ignore_patterns = [
          "^__pycache__/"
        ];
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
      "<A-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
    };

    cmp.settings.sources = [
      # {name = "codeium";}
      {name = "buffer";}
      {name = "nvim_lsp";}
      {name = "path";}
      {name = "luasnip";}
    ];

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

    visual-multi = {
      enable = true;
      settings = {
        maps = {
          "Add Cursor Down" = "<A-Down>";
          "Add Cursor Up" = "<A-Up>";
          "Mouse Cursor" = "<A-LeftMouse>";
          "Mouse Word" = "<A-RightMouse>";
          "Select All" = "<C-A-n>";
        };
        mouse_mappings = 1;
      };
    };

    wakatime.enable = true;

    smart-splits.enable = true;
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

    nvim-tree.enable = true;

    gitsigns = {
      enable = true;
      settings.current_line_blame = true;
    };

    # noice.enable = true;
    nui.enable = true;

    commentary.enable = true;
  };
}
