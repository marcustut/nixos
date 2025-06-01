{ ... }:

{
  imports = [
    # Hardware config (bootloader, kernel modules, filesystems, etc)
    ./hardware-configuration.nix

    # DNS Server (dnsmasq)
    ./dns.nix

    # Dynamic-DNS Server (ddns-route53)
    ./ddns.nix

    # Reverse proxy (nginx)
    ./nginx.nix

    # VPN (open-source tailscale)
    ./headscale.nix

    # Kubernetes cluster (k3s)
    ./k3s.nix

    # Password manager (bitwarden alternative)
    ./vaultwarden.nix

    # Relay server for rustdesk (open-source anydesk)
    ./rustdesk-relay.nix

    # Configuration for bore tunneling
    # ./bore.nix

    # Desktop environment (i3wm)
    ./i3.nix

    # Routing
    ./routes/minio.nix
    ./routes/nextcloud.nix
    ./routes/gitlab.nix
  ];
}
