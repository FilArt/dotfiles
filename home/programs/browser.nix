{pkgs, ...}: {
  services.psd.enable = true;
  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
    commandLineArgs = [
      "--enable-features=VaapiVideoEncoder"
      "--lang=ru-RU"
      ''--disk-cache-dir="/tmp/chrome-cache"''
    ];
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # darkreader
      "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
      "oldceeleldhonbafppcapldpdifcinji" # grammar
    ];
    dictionaries = with pkgs.hunspellDictsChromium; [
      en_US
      es_ES
      ru_RU
    ];
  };
}
