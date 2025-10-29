{
  programs.zellij = {
    enable = true;
    # enableZshIntegration = true;
    settings = {
      show_startup_tips = false;
      keybinds = {
        unbind = [
          "Alt j"
          "Alt k"
          "Alt o"
        ];
      };
    };
  };
}
