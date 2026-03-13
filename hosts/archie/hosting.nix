{
  config,
  lib,
  ...
}: let
  inherit (lib)
    attrValues
    literalExpression
    mapAttrs'
    mkIf
    mkOption
    nameValuePair
    optionalAttrs
    types
    unique
    ;

  cfg = config.archie.hosting;
  projects = cfg.projects;
  hostNames = builtins.map (project: project.hostName) (attrValues projects);

  mkProjectService = name: project:
    nameValuePair "backend-${name}" {
      description = "Backend project ${name}";
      after = unique ([ "network-online.target" ] ++ project.after);
      wants = unique ([ "network-online.target" ] ++ project.wants);
      wantedBy = [ "multi-user.target" ];
      environment = project.environment // {
        PORT = toString project.port;
      };
      serviceConfig =
        {
          Type = "simple";
          User = project.user;
          Group = project.group;
          ExecStart = project.execStart;
          Restart = "on-failure";
          RestartSec = "5s";
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          UMask = "0027";
        }
        // optionalAttrs (project.environmentFile != null) {
          EnvironmentFile = project.environmentFile;
        }
        // project.serviceConfig;
    };

  mkProjectVHost = name: project:
    nameValuePair name {
      inherit (project) hostName serverAliases;
      extraConfig = ''
        encode zstd gzip
        reverse_proxy 127.0.0.1:${toString project.port}
        ${project.caddyExtraConfig}
      '';
    };
in {
  options.archie.hosting = {
    caddyEmail = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "ops@example.com";
      description = "Email address used by Caddy for ACME registrations.";
    };

    projects = mkOption {
      default = {};
      type = with types;
        attrsOf (submodule ({name, ...}: {
          options = {
            hostName = mkOption {
              type = types.str;
              default = name;
              example = "api.example.com";
              description = "Primary hostname served by Caddy for this project.";
            };

            serverAliases = mkOption {
              type = with types; listOf str;
              default = [];
              example = ["www.api.example.com"];
              description = "Additional hostnames routed to the same backend.";
            };

            port = mkOption {
              type = types.port;
              example = 8000;
              description = "Local port the backend listens on.";
            };

            execStart = mkOption {
              type = types.str;
              example = literalExpression ''"${lib.getExe pkgs.nodejs} ./server.js"'';
              description = "Absolute ExecStart command for the backend service.";
            };

            user = mkOption {
              type = types.str;
              default = "archie";
              description = "System user used to run the backend service.";
            };

            group = mkOption {
              type = types.str;
              default = "users";
              description = "Primary group used to run the backend service.";
            };

            environment = mkOption {
              type = with types; attrsOf str;
              default = {};
              example = {
                NODE_ENV = "production";
              };
              description = "Environment variables exported to the backend service.";
            };

            environmentFile = mkOption {
              type = with types; nullOr str;
              default = null;
              example = "/run/secrets/api.env";
              description = "Optional environment file for secrets and runtime configuration.";
            };

            after = mkOption {
              type = with types; listOf str;
              default = [];
              example = ["postgresql.service"];
              description = "Additional units ordered before the backend service.";
            };

            wants = mkOption {
              type = with types; listOf str;
              default = [];
              example = ["postgresql.service"];
              description = "Additional units wanted by the backend service.";
            };

            caddyExtraConfig = mkOption {
              type = types.lines;
              default = "";
              example = ''
                header {
                  Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
                }
              '';
              description = "Additional Caddy directives appended to this virtual host.";
            };

            serviceConfig = mkOption {
              type = with types; attrsOf anything;
              default = {};
              example = literalExpression ''
                {
                  StateDirectory = "api";
                  RestartSec = "10s";
                }
              '';
              description = "Additional overrides merged into systemd.services.<name>.serviceConfig.";
            };
          };
        }));
      description = "Backend projects exposed through systemd services and Caddy reverse proxies.";
    };
  };

  config = mkIf (projects != {}) {
    assertions = [
      {
        assertion = hostNames == unique hostNames;
        message = "archie.hosting.projects must use unique hostName values.";
      }
    ];

    services.caddy = {
      enable = true;
      email = cfg.caddyEmail;
      openFirewall = true;
      virtualHosts = mapAttrs' mkProjectVHost projects;
    };

    systemd.services = mapAttrs' mkProjectService projects;
  };
}
