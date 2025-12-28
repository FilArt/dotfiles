{
  home.sessionVariables.TERMINAL = "kitty";

  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "RobotoMono Nerd Font:size=11";
        dpi-aware = "yes";
      };
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };

  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    enableGitIntegration = true;
    settings = {
      scrollback_lines = 100000;
      enable_audio_bell = false;
      update_check_interval = 0;
    };
  };
}
