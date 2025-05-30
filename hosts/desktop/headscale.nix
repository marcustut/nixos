{ config, ... }:

let
  base_domain = "balaenaquant.com";
  domain = "headscale.${base_domain}";
in
{
  services.tailscale.enable = true;
  services.openssh.enable = true;

  services.headscale = {
    enable = true;
    address = "0.0.0.0";
    port = 8080;
    settings = {
      dns.magic_dns = false;
      server_url = "https://${domain}:443";
    };
  };

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.headscale.port}";
      proxyWebsockets = true;
    };
  };

  security.acme = {
    acceptTerms = true;
    certs.${domain}.email = "marcuslee@balaenaquant.com";
  };

  # DERP port (https://tailscale.com/kb/1082/firewall-ports)
  networking.firewall.allowedUDPPorts = [ 3478 ];

  environment.systemPackages = [ config.services.headscale.package ];
}
