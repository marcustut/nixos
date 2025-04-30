{ ... }:

let
  base_domain = "balaenaquant.com";
  domain = "minio.${base_domain}";
  console_domain = "console.minio.${base_domain}";
in
{
  # networking hosts
  networking.hosts."192.168.0.111" = [ domain console_domain ];

  # gateway entry
  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://desktop.balaenaquant.local:9000";
      proxyWebsockets = true;
    };
  };
  services.nginx.virtualHosts.${console_domain} = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://desktop.balaenaquant.local:9001";
      proxyWebsockets = true;
    };
  };

  # ssl cert
  security.acme = {
    acceptTerms = true;
    certs.${domain}.email = "marcuslee@balaenaquant.com";
    certs.${console_domain}.email = "marcuslee@balaenaquant.com";
  };
}
