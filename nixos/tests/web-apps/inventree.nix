{ lib, ... }:
{
  name = "inventree";

  meta = {
    maintainers = with lib.maintainers; [ fsagbuya ];
  };

  nodes.machine =
    { ... }:
    {
      services.inventree.enable = true;

      # First-boot Django migrations + the bundled gunicorn worker need more
      # than the default VM memory.
      virtualisation.memorySize = 2048;
    };

  testScript = ''
    machine.start()

    with subtest("PostgreSQL provisioned by the module is up"):
        machine.wait_for_unit("postgresql.service")

    with subtest("Server unit boots (migrations may take a while)"):
        machine.wait_for_unit("inventree-server.service", timeout = 600)
        machine.wait_for_open_port(8000)

    with subtest("Background worker unit boots"):
        machine.wait_for_unit("inventree-worker.service")

    with subtest("HTTP server responds"):
        machine.succeed("curl -sSfL http://127.0.0.1:8000/api/ | grep -i 'inventree'")

    with subtest("inventree-manage works as root (sudo path)"):
        machine.succeed("inventree-manage check")

    with subtest("inventree-manage works as the service user (exec path)"):
        machine.succeed("sudo -u inventree inventree-manage check")
  '';
}
