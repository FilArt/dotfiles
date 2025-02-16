{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    nil
  ];

  programs.nixvim = {
    enable = true;
    colorschemes.oxocarbon.enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;

    globals.mapleader = " ";

    globalOpts = {
      relativenumber = true;
      signcolumn = "yes";
      mouse = "a";
      ignorecase = true;
      smartcase = true;
      splitright = true;
      splitbelow = true;

      # Tab defaults (might get overwritten by an LSP server)
      tabstop = 4;
      shiftwidth = 4;
      softtabstop = 0;
      expandtab = true;
      smarttab = true;

      # System clipboard support, needs xclip/wl-clipboard
      clipboard = {
        providers = {
          wl-copy.enable = true; # Wayland
        };
        register = "unnamedplus";
      };

      # Save undo history
      undofile = true;

      # Highlight the current line for cursor
      cursorline = true;

      # Show line and column when searching
      ruler = true;

      # Global substitution by default
      gdefault = true;

      # Start scrolling when the cursor is X lines away from the top/bottom
      scrolloff = 5;
    };

    keymaps = [
      # Neo-tree bindings
      {
        action = "<cmd>CHADopen<CR>";
        key = "<leader>e";
      }

      # Undotree
      {
        mode = "n";
        key = "<leader>ut";
        action = "<cmd>UndotreeToggle<CR>";
        options = {
          desc = "Undotree";
        };
      }

      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>LazyGit<CR>";
        options = {
          desc = "LazyGit (root dir)";
        };
      }

      # Commentary bindings
      {
        action = "<cmd>Commentary<CR>";
        key = "<leader>/";
      }

      {
        mode = "n";
        key = "<Tab>";
        action = "<cmd>BufferLineCycleNext<cr>";
        options = {
          desc = "Cycle to next buffer";
        };
      }

      {
        mode = "n";
        key = "<S-Tab>";
        action = "<cmd>BufferLineCyclePrev<cr>";
        options = {
          desc = "Cycle to previous buffer";
        };
      }

      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>BufferLineCycleNext<cr>";
        options = {
          desc = "Cycle to next buffer";
        };
      }

      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>BufferLineCyclePrev<cr>";
        options = {
          desc = "Cycle to previous buffer";
        };
      }

      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bdelete<cr>";
        options = {
          desc = "Delete buffer";
        };
      }
    ];

    plugins = {
      lastplace.enable = true;
      markdown-preview.enable = true;
      lazygit.enable = true;
      web-devicons.enable = true;
      bufferline.enable = true;
      lualine.enable = true;

      treesitter = {
        enable = true;
      };
      chadtree.enable = true;

      lint = {
        enable = true;
        lintersByFt = {
          text = [ "vale" ];
          json = [ "jsonlint" ];
          markdown = [ "vale" ];
          dockerfile = [ "hadolint" ];
          python = [ "ruff" ];
        };
      };

      gitsigns = {
        enable = true;
        settings.current_line_blame = true;
      };

      noice.enable = true;

      commentary.enable = true;

      lsp = {
        enable = true;
        servers = {
          ts_ls.enable = true; # TS/JS
          cssls.enable = true; # CSS
          html.enable = true; # HTML
          #vuejs.enable = true; # Vue
          pyright.enable = true; # Python
          marksman.enable = true; # Markdown
          nil_ls.enable = true; # Nix
          dockerls.enable = true; # Docker
          bashls.enable = true; # Bash
          yamlls.enable = true; # YAML
        };
      };

      lsp-format = {
        enable = true;
        autoLoad = true;
      };

      telescope = {
        enable = true;
        extensions = {
          fzf-native = {
            enable = true;
          };
        };
      };

      none-ls = {
        enable = true;
        settings = {
          cmd = [ "bash -c nvim" ];
          debug = true;
        };
        sources = {
          code_actions = {
            statix.enable = true;
            gitsigns.enable = true;
          };
          diagnostics = {
            statix.enable = true;
            deadnix.enable = true;
            pylint.enable = true;
            checkstyle.enable = true;
          };
          formatting = {
            alejandra.enable = true;
            shfmt.enable = true;
            nixpkgs_fmt.enable = true;
            google_java_format.enable = false;
            prettier = {
              enable = true;
              disableTsServerFormatter = true;
            };
            black = {
              enable = true;
              settings = ''
                {
                  extra_args = { "--fast" },
                }
              '';
            };
          };
          completion = {
            spell.enable = true;
          };
        };
      };
    };

    extraConfigLuaPost = ''
      -- vim: ts=2 sts=2 sw=2 et
    '';
  };
}
