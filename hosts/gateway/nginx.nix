{ ... }:

{
  # nginx
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    eventsConfig = ''
      worker_connections  2048;
    '';
    clientMaxBodySize = "0";
  };

  # firewall
  networking.firewall = {
    allowedTCPPorts = [
      80 # http
      443 # https
    ];
  };

  # networking hosts
  networking.hosts."192.168.0.111" = [ "hub.balaenaquant.com" ];
}
