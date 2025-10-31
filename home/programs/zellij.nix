{
  programs.zellij = {
    enable = true;
    # enableZshIntegration = true;
    settings = {
      show_startup_tips = false;
      keybinds = {
        "shared_except \"session\" \"locked\"" = {
          "bind \"Ctrl i\"".SwitchToMode = "Session";
        };
        unbind = [
          "Alt j"
          "Alt k"
          "Alt o"
          "Ctrl o"
        ];
      };
    };
  };
}
