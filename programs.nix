{ pkgs, ... }: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "''${pkgs.foot}/bin/foot";
        layer = "overlay";
      };
      colors.background = "1D1011ff";
      colors.text = "F7DCDEff";
      colors.selection = "574144ff";
      colors.selection-text = "DEBFC2ff";
      colors.border = "574144dd";
      colors.match = "FFB2BCff";
      colors.selection-match = "FFB2BCff";
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "CascadiaMono:size=11";

        dpi-aware = "yes";
      };
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
  programs.starship = {
    enable = true;
    settings = {
      username = {
        style_user = "blue bold";
        style_root = "red bold";
        format = "[$user]($style) ";
        disabled = false;
        show_always = true;
      };
      hostname = {
        ssh_only = false;
        ssh_symbol = "🌐 ";
        format = "on [$hostname](bold red) ";
        trim_at = ".local";
        disabled = false;
      };
    };
  };
  programs.gpg.enable = true;
  programs.password-store.enable = true;
  services.safeeyes.enable = true;
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    extensions = with pkgs.vscode-extensions; [
      ms-vscode-remote.remote-containers
      ms-python.python
      charliermarsh.ruff
      jnoortheen.nix-ide
      pkief.material-icon-theme
      ms-python.debugpy
      ms-python.vscode-pylance
    ];
    userSettings = {
      "editor.fontFamily" = "Cascadia Code";
      "editor.formatOnSave" = true;
      "[python]" = {
        "editor.defaultFormatter" = null;
        "editor.codeActionsOnSave" = {
          "source.fixAll" = "explicit";
        };
      };
    };
  };
  programs.ruff = {
    enable = true;
    settings = {
      line-length = 120;
    };
  };
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-lastplace
    ];
    extraPackages = with pkgs; [
      (python3.withPackages (ps: with ps; [
        ruff
        flake8
        pylint
      ]))
    ];
    extraPython3Packages = (ps: with ps; [
    ]);
  };
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
          repositories = [ "/home/art/mnt/onedrive/thinkpad_backup" ];
        };
        storage.encryptionPasscommand = "/run/current-system/sw/bin/cat /home/art/.borg-passphrase";
      };
    };
  };
  programs.zsh = {
    enable = true;
    oh-my-zsh.enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

}
