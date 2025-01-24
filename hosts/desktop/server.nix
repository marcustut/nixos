{ pkgs, config, ... }:

{
  # bore
  environment.systemPackages = with pkgs; [
    bore-cli # tcp tunneling
  ];

  # firewall
  networking.firewall = {
    allowedTCPPorts = [
      53 # dnsmasq
      80 # http
      443 # https
      7835 # bore
    ];
    allowedTCPPortRanges = [
      { from = 1024; to = 2048; } # bore server allowed ports
      { from = 21114; to = 21119; } # rustdesk allowed ports
    ];
    allowedUDPPorts = [
      53 # dnsmasq
      21116 # rustdesk relay
    ];
  };

  # startup processes
  systemd = {
    services.bore-server = {
      description = "Start bore server on login";
      path = [ pkgs.bore-cli ];
      script = ''
        #!/usr/bin/env bash
        bore server --min-port 1024 --max-port 2048
      '';
      serviceConfig = { Restart = "always"; };
      wantedBy = [ "multi-user.target" ];
      after = [ "syslog.target" "network.target" ];
    };
    services.bore-ssh = {
      description = "Forward SSH through bore on login";
      path = [ pkgs.bore-cli ];
      script = ''
        #!/usr/bin/env bash
        bore local 22 --to localhost --port 1024
      '';
      serviceConfig = { Restart = "always"; };
      wantedBy = [ "multi-user.target" ];
      after = [ "syslog.target" "network.target" ];
    };
    services.rustdesk-relay = {
      description = "Rustdesk Relay Server";
      path = [ pkgs.rustdesk-server ];
      script = ''
        #!/usr/bin/env bash
        hbbs &
        hbbr
      '';
      serviceConfig = { Restart = "always"; };
      wantedBy = [ "multi-user.target" ];
      after = [ "syslog.target" "network.target" ];
    };
    services.ddns-route53 = {
      description = "Dynamic DNS for Route 53";
      environment = {
        SCHEDULE = "*/30 * * * *";
      };
      script = ''
        #!/usr/bin/env bash
        HOME=/home/marcus
        $HOME/ddns-route53 --config $HOME/ddns-route53.yaml
      '';
      serviceConfig = {
        Type = "simple";
        RestartSec = 2;
        Restart = "always";
      };
      wantedBy = [ "multi-user.target" ];
      after = [ "syslog.target" "network.target" ];
    };
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
  };

  # systemd timers (cron)
  systemd.timers.backup-vaultwarden = {
    description = "Backup vaultwarden daily";
    wantedBy = [ "multi-user.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "backup-vaultwarden.service";
    };
  };

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

  # dnsmasq
  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;
    settings = {
      server = [ "1.1.1.1" "1.0.0.1" ]; # upstream dns (cloudflare)
      cache-size = 1000; # only cache up to 1000 dns queries
    };
  };

  # networking hosts
  networking.extraHosts = ''
    192.168.0.111 arvore.balaenaquant.com
    192.168.0.111 hub.balaenaquant.com
    192.168.0.111 vaultwarden.balaenaquant.com
    192.168.0.111 stream.datasource.hub.balaenaquant.com
    192.168.0.111 api.datasource.hub.balaenaquant.com
  '';

  # nginx
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."stream.datasource.hub.balaenaquant.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://10.43.62.251:7000";
        extraConfig = ''
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection $connection_upgrade;
        '';
      };
    };
    virtualHosts."api.datasource.hub.balaenaquant.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://10.43.222.82:7001";
      };
    };
    virtualHosts."vaultwarden.balaenaquant.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.vaultwarden.config.ROCKET_PORT}";
      };
    };
  };

  # ssl certs
  security.acme = {
    acceptTerms = true;
    certs = {
      "stream.datasource.hub.balaenaquant.com".email = "marcuslee@balaenaquant.com";
      "api.datasource.hub.balaenaquant.com".email = "marcuslee@balaenaquant.com";
      "vaultwarden.balaenaquant.com".email = "marcuslee@balaenaquant.com";
    };
  };
}
