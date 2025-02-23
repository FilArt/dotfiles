{ pkgs, ... }: {
  programs.borgmatic = {
    enable = true;
    backups = {
      basic = {
        location = {
          patterns = [
            "R /etc/nixos"
            "R /home/art"
            "- /home/art/roi"
            "- /home/art/.ollama"
            "- /home/art/mnt"
            "- /home/art/Projects"
            "- /home/art/.config/Slack/Cache"
            "- /home/art/.groovy"
            "- /home/art/.java"
            "- /home/art/.docker"
            "- /home/art/.tldrc"
            "- /home/art/Games"
            "- /home/art/.config/google-chrome"
            "- /home/art/.config/Slack"
            "- /home/art/.config/Code"
            "- /home/art/.config/JetBrains"
            "- /home/art/.cache"
            "- /home/art/.ipython"
            "- /home/art/Downloads"
            "- /home/art/.local"
            "- /home/art/.wine"
            "- /home/art/.codeium"
            "- /home/art/.vscode"
            "- /home/art/.bun"
            "- /home/art/.npm"
            "- /home/art/.paradoxlauncher"
            "- /home/art/.cursor"
            "- /home/art/.phoronix-test-suite"
            "- /home/art/.mozilla"
            "- /home/art/.compose-cache"
            "- /home/art/.local/share/JetBrains"
            "+ /home/art/.local/share/Trash"
          ];
          repositories = [ "ssh://i82i6syt@i82i6syt.repo.borgbase.com/./repo" ];
          extraConfig = {
            exclude_caches = true;
            exclude_patterns = [ "*node_modules*" "*.venv*" ];
            one_file_system = true;
          };
        };
        storage.encryptionPasscommand = "/run/current-system/sw/bin/cat /home/art/.borg-passphrase";
        retention = {
          keepDaily = 7;
          keepWeekly = 4;
          keepMonthly = 6;
        };
        consistency = {
          checks = [
            {
              name = "repository";
              frequency = "2 weeks";
            }
            {
              name = "archives";
              frequency = "2 weeks";
            }
          ];
        };
      };
    };
  };
}
