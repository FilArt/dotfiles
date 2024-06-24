{ pkgs, ... }: {
  programs.borgmatic = {
    enable = true;
    backups = {
      basic = {
        location = {
          patterns = [
            "+ /etc"
            "R /home/art"
            "- /home/art/roi"
            "- /home/art/.cache"
            "- /home/art/.ollama"
            "- /home/art/mnt"
            "- /home/art/Projects"
            "- /home/art/.config/Slack/Cache"
            "- /home/art/.groovy"
            "- /home/art/.java"
            "- /home/art/.docker"
            "- /home/art/.tldrc"
          ];
          repositories = [ "/home/art/mnt/gdrive/backups/nix" ];
        };
        storage.encryptionPasscommand = "/run/current-system/sw/bin/cat /home/art/.borg-passphrase";
      };
    };
  };
  services.borgmatic.enable = true;
}
