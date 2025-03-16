{...}: let
  mkKeymap = mode: key: action: {
    inherit mode key action;
    options = {
      silent = true;
    };
  };

  mkNormap = key: action: (mkKeymap "n" key action);
  mkInsmap = key: action: (mkKeymap "i" key action);
  mkVimap = key: action: (mkKeymap "v" key action);
  mkRawmap = key: rawAction: {
    inherit key;
    mode = "n";
    action.__raw = rawAction;
  };
in {
  programs.nixvim = {
    globals.mapleader = " ";
    globals.maplocalleader = " ";

    keymaps = [
      (mkNormap "<C-s>" ":w<CR>")
      (mkInsmap "<C-s>" ":w<CR>")
      (mkNormap "<leader>p" ":Telescope projects<CR>")

      (mkNormap "<leader>e" ":Neotree toggle<CR>")
      (mkNormap "<leader>ut" ":UndotreeToggle<CR>")
      (mkNormap "<leader>gg" ":LazyGit<CR>")
      (mkNormap "<leader>/" ":Commentary<CR>")

      (mkNormap "<leader>ff" ":Telescope find_files<CR>")
      (mkNormap "<leader>fw" ":Telescope live_grep<CR>")
      (mkNormap "<leader>fg" ":Telescope git_commits<CR>")
      (mkNormap "<leader>fh" ":Telescope oldfiles<CR>")

      (mkRawmap "<C-h>" "require(\"smart-splits\").move_cursor_left")
      (mkRawmap "<C-l>" "require(\"smart-splits\").move_cursor_right")
      (mkRawmap "<C-k>" "require(\"smart-splits\").move_cursor_up")
      (mkRawmap "<C-j>" "require(\"smart-splits\").move_cursor_down")

      (mkNormap "<Tab>" ":BufferNext<CR>")
      (mkNormap "<S-Tab>" ":BufferPrevious<CR>")
      (mkNormap "<S-w>" ":BufferClose<CR>")

      (mkNormap "<leader>db" ":lua require(\"dap\").toggle_breakpoint()<CR>")
      (mkNormap "<leader>de" ":lua require(\"dapui\").eval()<CR>")
      (mkNormap "<leader>dc" ":lua require(\"dap\").continue()<CR>")
      (mkNormap "<leader>dn" ":lua require(\"dap\").step_over()<CR>")
      (mkNormap "<leader>di" ":lua require(\"dap\").step_into()<CR>")
      (mkNormap "<leader>do" ":lua require(\"dap\").step_out()<CR>")
      (mkNormap "<leader>dr" ":lua require(\"dap\").repl.open()<CR>")
      (mkNormap "<leader>dl" ":lua require(\"dap\").run_last()<CR>")
    ];
  };
}
