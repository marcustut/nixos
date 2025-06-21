{ pkgs, ... }:

{
  # mobile device integration
  services.usbmuxd.enable = true;
  environment.systemPackages = with pkgs; [
    libimobiledevice # mobile tethering
    ifuse # ios mount
  ];
}

