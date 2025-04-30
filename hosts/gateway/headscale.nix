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

  # networking hosts
  networking.hosts."192.168.0.111" = [ domain ];

  # gateway entry
  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.headscale.port}";
      proxyWebsockets = true;
    };
  };

  # ssl cert
  security.acme = {
    acceptTerms = true;
    certs.${domain}.email = "marcuslee@balaenaquant.com";
  };

  environment.systemPackages = [ config.services.headscale.package ];
}
