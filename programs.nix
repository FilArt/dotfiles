{...}: {
  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
      env = {
        __NV_PRIME_RENDER_OFFLOAD = "1";
        __VK_LAYER_NV_optimus = "NVIDIA_only";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      };
    };
    steam = {
      enable = true;
      gamescopeSession = {
        enable = true;
      };
    };
    gamemode.enable = true;

    zsh.enable = true;
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    nh = {
      enable = true;
      clean.enable = false;
      flake = "/home/art/.config/home-manager";
    };
  };
}
