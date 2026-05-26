{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.inventree;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "inventree-config.yaml" cfg.settings;

  # Hardcoded to match `StateDirectory` below.
  dataDir = "/var/lib/inventree";

  inventree-manage = pkgs.writeShellScriptBin "inventree-manage" ''
    set -o allexport
    INVENTREE_CONFIG_FILE=${configFile}
    set +o allexport

    sudo=exec
    if [[ "$USER" != "${cfg.user}" ]]; then
      ${
        if config.security.sudo.enable then
          "sudo='exec ${config.security.wrapperDir}/sudo -u ${cfg.user} -E'"
        else
          ">&2 echo 'Aborting, inventree-manage must be run as user `${cfg.user}`!'; exit 2"
      }
    fi
    $sudo ${lib.getExe cfg.package} "$@"
  '';
in
{
  options.services.inventree = {
    enable = lib.mkEnableOption "InvenTree, an open source inventory management system";

    package = lib.mkPackageOption pkgs "inventree" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "inventree";
      description = "User account under which InvenTree runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "inventree";
      description = "Group under which InvenTree runs.";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address the gunicorn server will bind to.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      description = "Port the gunicorn server will bind to.";
    };

    secretKeyFile = lib.mkOption {
      type = lib.types.str;
      default = "${dataDir}/secret_key.txt";
      description = ''
        Path to a file containing the Django `SECRET_KEY`. If the file does
        not exist on first start, InvenTree will generate a random key and
        write it there automatically.

        The file must be writable by {option}`services.inventree.user`.
      '';
    };

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to set up a local PostgreSQL database and grant the
          InvenTree user access via peer authentication over the unix socket.
        '';
      };
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = {
          site_url = lib.mkOption {
            type = lib.types.str;
            default = "http://localhost:${toString cfg.port}";
            example = "https://inventree.example.com";
            description = ''
              Externally visible URL of the InvenTree instance. This must
              match the URL that users access the server through.
            '';
          };
          allowed_hosts = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ "*" ];
            description = ''
              List of host headers the Django site will accept.
            '';
          };
        };
      };
      default = { };
      description = ''
        Freeform settings written to InvenTree's `config.yaml`.
        See <https://docs.inventree.org/en/stable/start/config/> for the full
        list of supported options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.inventree.settings = {
      debug = lib.mkDefault false;
      static_root = lib.mkDefault "${cfg.package}/lib/inventree/static";
      media_root = lib.mkDefault "${dataDir}/media";
      backup_dir = lib.mkDefault "${dataDir}/backup";
      secret_key_file = lib.mkDefault cfg.secretKeyFile;

      # InvenTree auto-creates these on first load; without explicit paths
      # they fall back to /nix/store (next to config.yaml) and crash.
      plugin_file = lib.mkDefault "${dataDir}/plugins.txt";
      oidc_private_key_file = lib.mkDefault "${dataDir}/oidc.pem";

      database = lib.mkIf cfg.database.createLocally {
        engine = lib.mkDefault "postgresql";
        name = lib.mkDefault "inventree";
        user = lib.mkDefault cfg.user;
        host = lib.mkDefault "/run/postgresql";
      };
    };

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ "inventree" ];
      ensureUsers = [
        {
          name = cfg.user;
          ensureDBOwnership = true;
        }
      ];
    };

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = dataDir;
    };
    users.groups.${cfg.group} = { };

    environment.systemPackages = [ inventree-manage ];

    systemd.services =
      let
        commonServiceConfig = {
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = dataDir;
          StateDirectory = "inventree";
          StateDirectoryMode = "0750";
          Restart = "on-failure";
          RestartSec = 5;
        };
        commonEnv = {
          INVENTREE_CONFIG_FILE = "${configFile}";
        };
      in
      {
        inventree-server = {
          description = "InvenTree HTTP server";
          documentation = [ "https://docs.inventree.org/" ];
          wantedBy = [ "multi-user.target" ];
          after = [
            "network-online.target"
          ]
          ++ lib.optional cfg.database.createLocally "postgresql.service";
          requires = lib.optional cfg.database.createLocally "postgresql.service";
          wants = [ "network-online.target" ];

          environment = commonEnv;

          preStart = ''
            mkdir -p ${dataDir}/media ${dataDir}/backup
            ${cfg.package}/bin/inventree migrate --no-input
          '';

          serviceConfig = commonServiceConfig // {
            ExecStart = ''
              ${cfg.package}/bin/gunicorn \
                --bind ${cfg.host}:${toString cfg.port} \
                InvenTree.wsgi
            '';
            TimeoutStartSec = "10min";
          };
        };

        inventree-worker = {
          description = "InvenTree background worker (django-q2 cluster)";
          documentation = [ "https://docs.inventree.org/" ];
          wantedBy = [ "multi-user.target" ];
          after = [ "inventree-server.service" ];

          environment = commonEnv;

          serviceConfig = commonServiceConfig // {
            ExecStart = "${cfg.package}/bin/inventree qcluster";
          };
        };
      };
  };

  meta.maintainers = with lib.maintainers; [ fsagbuya ];
}
