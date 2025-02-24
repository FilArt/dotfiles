{...}: let
  mkKeymap = mode: key: action: {
    inherit mode key action;
    options = {
      silent = true;
    };
  };

  mkNormap = key: action: (mkKeymap "n" key action);
  # mkInsmap = key: action: (mkKeymap "i" key action);
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
      (mkNormap "<C-s>" ":w<CR>") # Save
      (mkNormap "<C-S-p>" "require(\"telescope\").extensions.projects.projects{}")

      (mkNormap "<leader>e" ":Neotree toggle<CR>")
      (mkNormap "<leader>ut" ":UndotreeToggle<CR>")
      (mkNormap "<leader>gg" ":LazyGit<CR>")
      (mkNormap "<leader>/" ":Commentary<CR>")
      (mkNormap "<leader>bd" ":BufferClose<CR>")

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
    ];
  };
}
