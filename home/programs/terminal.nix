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

  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        padding = {
          x = 6;
          y = 6;
        };
        decorations = "full";
        opacity = 0.95;
        dynamic_padding = true;
      };

      scrolling = {
        history = 100000;
        multiplier = 3;
      };

      cursor = {
        style = "Beam";
        unfocused_hollow = true;
      };

      colors = {
        primary = {
          background = "0x1e1e2e";
          foreground = "0xcdd6f4";
        };
        normal = {
          black = "0x45475a";
          red = "0xf38ba8";
          green = "0xa6e3a1";
          yellow = "0xf9e2af";
          blue = "0x89b4fa";
          magenta = "0xf5c2e7";
          cyan = "0x94e2d5";
          white = "0xbac2de";
        };
      };

      selection.save_to_clipboard = true;
    };
  };
}
