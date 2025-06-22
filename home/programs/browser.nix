{pkgs, ...}: {
  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
    commandLineArgs = [
      "--lang=ru-RU"
      ''--disk-cache-dir="/run/user/1000/chrome-cache"''
    ];
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # darkreader
      "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
      "oldceeleldhonbafppcapldpdifcinji" # grammar
    ];
    dictionaries = with pkgs.hunspellDictsChromium; [
      en_US
      # es_ES
      # ru_RU
    ];
  };
}
