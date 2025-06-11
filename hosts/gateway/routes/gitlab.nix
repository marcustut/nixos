{ ... }:

let
  base_domain = "balaenaquant.com";
  domain = "gitlab.${base_domain}";
in
{
  # networking hosts
  networking.hosts."192.168.0.111" = [ domain ];

  # gateway entry
  services.nginx = {
    virtualHosts.${domain} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://nas.balaenaquant.local:8080";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header X-Forwarded-Proto https;
          proxy_set_header X-Forwarded-Ssl on;
        '';
      };
    };

    streamConfig = ''
      server {
          listen 22;
          proxy_pass nas.balaenaquant.local:22;
      }
    '';
  };

  # ssl cert
  security.acme = {
    acceptTerms = true;
    certs.${domain}.email = "marcuslee@balaenaquant.com";
  };
}
