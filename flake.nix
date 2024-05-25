{
  description = "NixOS configuration";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    # Home manager, for declaratively configure dotfiles
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland window manager
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { home-manager, nixpkgs, ... }@inputs:
    let
      mkSystem = system: hostname:
        nixpkgs.lib.nixosSystem {
          modules = [
            { networking.hostName = hostname; }
            # General configuration (users, networking, sound, etc)
            ./modules/system/configuration.nix
            # Hardware config (bootloader, kernel modules, filesystems, etc)
            (./. + "/hosts/${hostname}/hardware-configuration.nix")
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                extraSpecialArgs = { inherit inputs; };
                # Home manager config (configures programs like firefox, zsh, eww, etc)
                users.marcus = (./. + "/hosts/${hostname}/user.nix");
              };
            }
          ];
          specialArgs = { inherit inputs; };
        };
    in
    {
      nixosConfigurations = {
        nixos = mkSystem "x86_64-linux" "nixos";
      };
    };
}
