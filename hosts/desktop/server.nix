{ pkgs, ... }:

{
  # bore
  environment.systemPackages = with pkgs; [
    bore-cli # tcp tunneling
  ];

  # firewall
  networking.firewall = {
    allowedTCPPorts = [ 80 443 7835 ];
    allowedTCPPortRanges = [
      { from = 1024; to = 2048; } # bore server allowed ports
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
    services.equities-tracker = {
      description = "An equities tracker";
      path = [ pkgs.nodejs pkgs.nodePackages.pnpm ];
      script = ''
        #!/usr/bin/env bash
        HOME=/home/marcus
        cd $HOME/cybotrade/equities-tracker
        node index.mjs
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

  # nginx
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."extract-request.balaenaquant.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3001";
      };
    };
    virtualHosts."api.marcustut.me" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:5123";
      };
    };
  };

  # ssl certs
  security.acme = {
    acceptTerms = true;
    certs = {
      "extract-request.balaenaquant.com".email = "marcuslee@balaenaquant.com";
      "api.marcustut.me".email = "marcustutorial@hotmail.com";
    };
  };
}
