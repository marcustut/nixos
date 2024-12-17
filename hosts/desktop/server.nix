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
      { from = 21114; to = 21119; } # rustdesk allowed ports
    ];
    allowedUDPPorts = [ 21116 ];
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 0 * * *      root      prime-cli backup" # cronjob to perform plane backup
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
  };

  # nginx
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."plane.balaenaquant.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:5124";
      };
    };
  };

  # ssl certs
  security.acme = {
    acceptTerms = true;
    certs = {
      "plane.balaenaquant.com".email = "marcuslee@balaenaquant.com";
    };
  };
}
