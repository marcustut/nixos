{ config, ... }:

{
  networking.firewall.allowedTCPPorts = [
    9000
    9001
  ];

  services.minio = {
    enable = true;
    dataDir = [ "/minio/data" ];
    configDir = "/minio/config";
    region = "ap-southeast-5";
    rootCredentialsFile = "${toString config.users.users.marcus.home}/.minio.env";
  };
}
