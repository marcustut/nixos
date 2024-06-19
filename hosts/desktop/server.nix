{ pkgs, ... }:

{
  # bore
  environment.systemPackages = with pkgs; [
    bore-cli # tcp tunneling
  ];

  # firewall
  networking.firewall = {
    allowedTCPPorts = [ 80 443 7835 ];
    allowedTCPPortRanges = [
      { from = 1024; to = 2048; } # bore server allowed ports
    ];
  };

  # startup processes
  systemd = {
    services.bore-server = {
      description = "Start bore server on login";
      path = [ pkgs.bore-cli ];
      script = ''
        #!/usr/bin/env bash
        bore server --min-port 1024 --max-port 2048
      '';
      wantedBy = [ "multi-user.target" ]; # starts after login
    };
    services.bore-ssh = {
      description = "Forward SSH through bore on login";
      path = [ pkgs.bore-cli ];
      script = ''
        #!/usr/bin/env bash
        bore local 22 --to localhost --port 1024
      '';
      wantedBy = [ "multi-user.target" ]; # starts after login
    };
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
