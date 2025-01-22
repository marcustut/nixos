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
