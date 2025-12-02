{lib, ...}: let
  enableKitty = false;
in {
  programs.kitty = {
    enable = enableKitty;
    shellIntegration.enableZshIntegration = true;
    environment = {
      TERM = "xterm-256color";
    };
    enableGitIntegration = true;
    settings = {
      scrollback_lines = 100000;
      enable_audio_bell = false;
      update_check_interval = 0;
    };
  };

  home.sessionVariables.TERMINAL = lib.mkIf enableKitty "kitty";
}
