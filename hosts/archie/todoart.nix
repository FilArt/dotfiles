{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit
    (lib)
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.archie.todoart;
  todoartApiPackage = import "${inputs.todoart-api}/api" {inherit pkgs;};
in {
  options.archie.todoart = {
    enable = mkEnableOption "TodoArt FastAPI backend on the archie host";

    package = mkOption {
      type = types.package;
      default = todoartApiPackage;
      defaultText = literalExpression "import inputs.todoart-api { inherit pkgs; }";
      description = "The packaged TodoArt API executable deployed to archie.";
    };

    domain = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "todo-api.example.com";
      description = "Public hostname that Caddy should serve for the TodoArt API.";
    };

    serverAliases = mkOption {
      type = with types; listOf str;
      default = [];
      example = ["api.todo.example.com"];
      description = "Additional hostnames routed to the same TodoArt backend.";
    };

    port = mkOption {
      type = types.port;
      default = 8000;
      description = "Local listen port used by the TodoArt process.";
    };

    environmentFile = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "/run/secrets/todoart-api.env";
      description = "Optional environment file loaded by the TodoArt backend service.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.domain != null;
        message = "Set archie.todoart.domain before enabling the TodoArt host module.";
      }
    ];

    users.groups.todoart = {};
    users.users.todoart = {
      isSystemUser = true;
      group = "todoart";
    };

    archie.hosting.projects.todoart-api = {
      hostName = cfg.domain;
      inherit (cfg) environmentFile port serverAliases;
      user = "todoart";
      group = "todoart";
      execStart = "${lib.getExe cfg.package} --host 127.0.0.1 --port ${toString cfg.port}";
      serviceConfig.StateDirectory = "todoart";
    };
  };
}
