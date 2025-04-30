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
  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}
