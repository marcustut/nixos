{ config, pkgs, ... }:

let
  base_domain = "balaenaquant.com";
  domain = "vaultwarden.${base_domain}";
in
{
  # vaultwarden
  services.vaultwarden = {
    enable = true;
    environmentFile = "${toString config.users.users.marcus.home}/.vaultwarden.env";
    config = {
      ROCKET_ADDRESS = "::1";
      ROCKET_PORT = 8222;
      SIGNUPS_ALLOWED = false;
    };
  };

  systemd = {
    # systemd service
    services.backup-vaultwarden = {
      description = "Backup vaultwarden";
      environment = {
        HOME = "${toString config.users.users.marcus.home}";
        S3_BUCKET = "balaenaquant-vaultwarden";
      };
      path = with pkgs; [ gnutar gzip awscli2 ];
      before = [ "vaultwarden.service" ];
      script = ''
        #!/usr/bin/env bash
        # Set the script to exit immediately if any command fails
        set -e
        
        DATE=$(date +%Y-%m-%d)
        BACKUP_DIR=$HOME/backups/vaultwarden
        BACKUP_FILE=vaultwarden-$DATE.tar.gz
        CONTAINER=vaultwarden
        DATA_DIR=/var/lib/vaultwarden

        # create backups directory if it does not exist
        mkdir -p $BACKUP_DIR
        
        # Backup the vaultwarden data directory to the backup directory
        tar -czf "$BACKUP_DIR/$BACKUP_FILE" -C "$DATA_DIR" .

        # Upload the backup file to s3 bucket
        aws s3 cp $BACKUP_DIR/$BACKUP_FILE s3://$S3_BUCKET/
        
        # To delete files older than 30 days
        find $BACKUP_DIR/* -mtime +30 -exec rm {} \;
      '';
      serviceConfig = {
        SyslogIdentifier = "backup-vaultwarden";
        Type = "oneshot";
        User = "root";
      };
      wantedBy = [ "multi-user.target" ];
    };

    # systemd timers (cron)
    timers.backup-vaultwarden = {
      description = "Backup vaultwarden daily";
      wantedBy = [ "multi-user.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        Unit = "backup-vaultwarden.service";
      };
    };
  };

  # networking hosts
  networking.hosts."192.168.0.111" = [ domain ];

  # gateway entry
  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.vaultwarden.config.ROCKET_PORT}";
    };
  };

  # ssl cert
  security.acme = {
    acceptTerms = true;
    certs.${domain}.email = "marcuslee@balaenaquant.com";
  };
}
