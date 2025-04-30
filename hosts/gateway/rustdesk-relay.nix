{ pkgs, ... }:

{
  # networking 
  networking.firewall = {
    allowedTCPPortRanges = [{ from = 21114; to = 21119; }];
    allowedUDPPorts = [ 21116 ];
  };

  # startup process
  systemd.services.rustdesk-relay = {
    description = "Rustdesk Relay Server";
    path = [ pkgs.rustdesk-server ];
    script = ''
      #!/usr/bin/env bash
      hbbs &
      hbbr -k _
    '';
    serviceConfig = { Restart = "always"; };
    wantedBy = [ "multi-user.target" ];
    after = [ "syslog.target" "network.target" ];
  };
}
