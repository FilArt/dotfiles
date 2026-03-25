{
  programs.zellij = {
    enable = true;
    # enableZshIntegration = true;
    settings = {
      show_startup_tips = false;
      keybinds = {
        "shared_except \"session\" \"locked\"" = {
          "bind \"Ctrl i\"".SwitchToMode = "Session";
        };
        unbind = [
          "Alt j"
          "Alt k"
          "Alt o"
          "Ctrl o"
        ];
      };
    };

    layouts = {
      gg = {
        layout = {
          _props = {
            cwd = "~/Projects/call-visit";
          };
          _children = [
            {
              default_tab_template = {
                _children = [
                  {
                    pane = {
                      size = 1;
                      borderless = true;
                      plugin = {
                        location = "zellij:tab-bar";
                      };
                    };
                  }
                  {children = {};}
                  # {
                  #   pane = {
                  #     size = 2;
                  #     borderless = true;
                  #     plugin = {
                  #       location = "zellij:status-bar";
                  #     };
                  #   };
                  # }
                ];
              };
            }

            {
              tab = {
                _props = {
                  name = "Project";
                  focus = true;
                  split_direction = "vertical";
                };
                _children = [
                  {
                    pane = {
                      command = "devenv";
                      args = ["shell" "--" "uv" "run" "hx"];
                      borderless = true;
                      size = "60%";
                    };
                  }
                  {
                    pane = {};
                  }
                ];
              };
            }

            {
              tab = {
                _props = {
                  name = "Codex";
                };
                _children = [
                  {
                    pane = {
                      command = "codex";
                    };
                  }
                ];
              };
            }

            {
              tab = {
                _props = {
                  name = "Git";
                };
                _children = [
                  {
                    pane = {
                      command = "lazygit";
                    };
                  }
                ];
              };
            }

            {
              tab = {
                _props = {
                  name = "Processes";
                };
                _children = [
                  {
                    pane = {
                      command = "devenv";
                      args = ["up"];
                      start_suspended = true;
                    };
                  }
                ];
              };
            }
          ];
        };
      };
    };
  };
}
