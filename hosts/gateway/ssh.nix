{ ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 23 ]; # listen for SSH traffic on port 23
  };
}
