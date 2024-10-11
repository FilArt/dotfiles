{ pkgs, ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
    commandLineArgs = [
      "--enable-features=VaapiVideoEncoder"
      "--lang=ru-RU"
    ];
    dictionaries = with pkgs.hunspellDictsChromium; [
      en_US
      es_ES
      ru_RU
    ];
  };
}
