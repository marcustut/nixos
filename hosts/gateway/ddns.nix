{ ... }:

{
  # TODO: properly configure ddns-route53 into a nixpkg.
  systemd.services.ddns-route53 = {
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
}
