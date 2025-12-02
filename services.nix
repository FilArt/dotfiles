{pkgs, ...}: let
  mkRule = name: type: {
    inherit name type;
  };
in {
  services = {
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
      extraRules = [
        # compilers
        (mkRule "gcc" "BG_CPUIO")
        (mkRule "g++" "BG_CPUIO")
        (mkRule "cicc" "BG_CPUIO")
        (mkRule "ptxas" "BG_CPUIO")
        (mkRule "clang" "BG_CPUIO")
        (mkRule "mold" "BG_CPUIO")
        (mkRule "ld" "BG_CPUIO")
        (mkRule "gold" "BG_CPUIO")
        (mkRule "rustc" "BG_CPUIO")
        (mkRule "zig" "BG_CPUIO")
        (mkRule "cargo" "BG_CPUIO")
        (mkRule "rust-analyzer" "BG_CPUIO")
        (mkRule "go" "BG_CPUIO")
        (mkRule "nix" "BG_CPUIO")
        (mkRule "nix-daemon" "BG_CPUIO")
        # editors
        (mkRule "pycharm" "Doc-View")
        (mkRule "cursor" "Doc-View")
        # browser
        (mkRule "chrome" "Doc-View")
        # wm
        (mkRule "Hyprland" "LowLatency_RT")
        (mkRule "qtile" "LowLatency_RT")
        (mkRule "rofi" "LowLatency_RT")
        (mkRule "niri" "LowLatency_RT")

        # term
        (mkRule "wezterm-gui" "Doc-View")
        (mkRule "kitty" "Doc-View")
        (mkRule "foot" "Doc-View")
        (mkRule "alacritty" "Doc-View")

        # other
        (mkRule "wpaperd" "BG_CPUIO")
      ];
    };
    blueman.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    gvfs.enable = true;
    power-profiles-daemon.enable = true;
    printing.enable = false;
    upower.enable = true;
    udev.enable = true;
    udev.extraRules = ''
      # HDD
      ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
      # SSD
      ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"
      # NVMe SSD
      ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"
    '';
    udev.extraHwdb = ''
      evdev:input:b0003v046DpC548e0111*
       KEYBOARD_KEY_700e4=sysrq
       KEYBOARD_KEY_700e6=print
    '';

    kmscon = {
      enable = true;
      hwRender = true;
      useXkbConfig = true;
      extraOptions = "--font-dpi=192";
      autologinUser = "art";
    };
    greetd = {
      enable = true;
      settings = rec {
        default_session = {
          command = "${pkgs.greetd}/bin/agreety --cmd \"uwsm start niri-uwsm.desktop\"";
          user = "art";
        };
        initial_session = default_session;
      };
    };
  };
}
