{ config, ... }:

{
  services.tailscale.enable = true;

  networking = {
    hosts = {
      "100.64.0.4" = [ "mac-mini-m2" ];
      "100.64.0.7" = [ "desktop" ];
    };
    firewall = {
      checkReversePath = "loose";
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };
}
