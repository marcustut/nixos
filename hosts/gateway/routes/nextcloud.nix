{ ... }:

let
  base_domain = "balaenaquant.com";
  domain = "nextcloud.${base_domain}";
in
{
  # networking hosts
  networking.hosts."192.168.0.111" = [ domain ];

  # gateway entry
  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://nas.balaenaquant.local:80";
      proxyWebsockets = true;
    };
  };

  # ssl cert
  security.acme = {
    acceptTerms = true;
    certs.${domain}.email = "marcuslee@balaenaquant.com";
  };
}
