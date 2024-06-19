{ ... }:

{
  # tailscale
  services.tailscale = {
    enable = true;
  };

  # firewall
  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
  };

  # nginx
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."finance.marcustut.me" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
      };
    };
  };

  # ssl certs
  security.acme = {
    acceptTerms = true;
    certs = {
      "finance.marcustut.me".email = "marcustutorial@hotmail.com";
    };
  };
}
