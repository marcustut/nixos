{ pkgs, ... }:

{
  # startup processes
  systemd = {
    services.bore-server = {
      description = "Start bore server on login";
      path = [ pkgs.bore-cli ];
      script = ''
        #!/usr/bin/env bash
        bore server --min-port 1024 --max-port 2048
      '';
      serviceConfig = { Restart = "always"; };
      wantedBy = [ "multi-user.target" ];
      after = [ "syslog.target" "network.target" ];
    };
    services.bore-ssh = {
      description = "Forward SSH through bore on login";
      path = [ pkgs.bore-cli ];
      script = ''
        #!/usr/bin/env bash
        bore local 22 --to localhost --port 1024
      '';
      serviceConfig = { Restart = "always"; };
      wantedBy = [ "multi-user.target" ];
      after = [ "syslog.target" "network.target" ];
    };
  };

  # networking
  networking.firewall = {
    allowedTCPPorts = [ 7835 ];
    allowedTCPPortRanges = [
      { from = 1024; to = 2048; } # bore server allowed ports
    ];
  };

  # packages
  environment.systemPackages = with pkgs; [ bore-cli ];
}
