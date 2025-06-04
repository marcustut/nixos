{ pkgs, ... }:

{
  # nginx
  services.nginx = {
    enable = true;
    package = pkgs.nginx.override { withStream = true; };
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    eventsConfig = ''
      worker_connections  2048;
    '';
    clientMaxBodySize = "0";

    # Reroute SSH traffic
    streamConfig = ''
      server {
          listen 24;
          proxy_pass mac-mini-m2.balaenaquant.local:22;
      }
    '';
  };

  # firewall
  networking.firewall = {
    allowedTCPPortRanges = [{ from = 22; to = 32; }]; # SSH forwarding
    allowedTCPPorts = [
      80 # http
      443 # https
    ];
  };

  # networking hosts
  networking.hosts."192.168.0.111" = [ "hub.balaenaquant.com" ];
}
