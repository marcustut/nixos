{ ... }:

{
  # dnsmasq
  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;
    settings = {
      server = [ "1.1.1.1" "1.0.0.1" ]; # upstream dns (cloudflare)
      cache-size = 1000; # only cache up to 1000 dns queries
    };
  };

  # networking
  networking = {
    firewall = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];
    };
    hosts."192.168.0.111" = [ "gateway.balaenaquant.local" ];
    hosts."192.168.0.113" = [ "mac-mini-m2.balaenaquant.local" ];
    hosts."192.168.0.114" = [ "desktop.balaenaquant.local" ];
  };
}
