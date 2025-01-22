{ config, ... }:

{
  networking.firewall.allowedTCPPorts = [
    6443 # k3s API Server
    2379 # k3s etcd clients
    2380 # k3s etcd peers
  ];
  networking.firewall.allowedUDPPorts = [
    8472 # k3s flannel for inter-node networking (multi-node setup)
  ];

  services.k3s = {
    enable = true;
    role = "server";
    token = "${config.users.users.marcus.home}/.k3s.token";
    clusterInit = true;
    extraFlags = "--disable=traefik --tls-san=192.168.0.111 --tls-san=hub.balaenaquant.com";
  };
}
