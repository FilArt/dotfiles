{pkgs, ...}: {
  imports = [
    ./lsp.nix
  ];
  programs.nixvim.nixpkgs.config.allowUnfree = true;

  programs.nixvim.extraPlugins = with pkgs; [
    vimPlugins.supermaven-nvim
  ];

  programs.nixvim.plugins = {
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
    nvim-autopairs.enable = true;

    codeium-nvim.enable = true;

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
      # Snippet Engine & its associated nvim-cmp source
      # https://nix-community.github.io/nixvim/plugins/luasnip/index.html
      {name = "luasnip";}
      {name = "buffer";}
      {
        name = "codeium";
      }
      # Adds other completion capabilites.
      #  nvim-cmp does not ship with all sources by default. They are split
      #  into multiple repos for maintenance purposes.
      # https://nix-community.github.io/nixvim/plugins/cmp-nvim-lsp.html
      {
        name = "nvim_lsp";
      }
      # https://nix-community.github.io/nixvim/plugins/cmp-path.html
      {name = "path";}
    ];

    conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lspFallback = true;
          timeoutMs = 500;
        };
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
    dap-python.enable = true;
    dap-ui.enable = true;
    smart-splits.enable = true;
    undotree.enable = true;
    which-key.enable = true;
    lastplace.enable = true;
    lazygit.enable = true;
    web-devicons.enable = true;
    bufferline.enable = true;
    lualine.enable = true;
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

    noice.enable = true;

    commentary.enable = true;
  };
}
