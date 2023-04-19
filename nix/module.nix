self: { config, lib, pkgs, ... }:

let
  cfg = config.services.firefly-bot;
in {
  options.services.firefly-bot = {
    enable = lib.mkEnableOption "Firefly Bot";
    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${pkgs.system}.default;
      description = "The package implementing firefly bot";
    };
    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = "File path containing (secret) environment variables (i.e. TELEGRAM_BOT_TOKEN).";
      default = null;
    };
    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/firefly-bot";
      description = ''
        Path the bot will use to store user-generated data.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.firefly-bot = {
      description = "Firefly Bot";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/firefly-bot";
        Restart = "on-failure";
        User = "firefly-bot";
        WorkingDirectory = cfg.dataDir;
        EnvironmentFile = "${cfg.environmentFile}";
      };
    };

    users = {
      users.firefly-bot = {
        description = "firefly-bot service user";
        isSystemUser = true;
        group = "firefly-bot";
        createHome = true;
        home = cfg.dataDir;
      };
      groups.firefly-bot = { };
    };
  };
}
