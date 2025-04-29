{ pkgs, ... }:

{
  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Useful other development tools
  environment = {
    systemPackages = with pkgs; [
      qemu # open source machine emulator and virtualizer
      virtiofsd # virtio-fs backend in rust

      # dive # look into docker image layers
      podman-compose # start group of containers for dev
      podman-tui # status of containers in the terminal
      # docker-compose # start group of containers for dev
    ];
    sessionVariables = {
      DOCKER_HOST = "unix:///run/user/1000/podman/podman-machine-default-api.sock";
    };
  };
}
