{
  programs.bash = {
    enable = true;
    initExtra = ''
      alias ll='ls -lah'
    '';
  };
}
