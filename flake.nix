{
  description = "NixOS configuration";

  inputs = {
    # NixOS official package source, using the nixos-24.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    # Unstable channel
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # NixOS Windows Subsystem for Linux (WSL)
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # Home manager, for declaratively configure dotfiles
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland window manager
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { home-manager, nixpkgs, nixos-wsl, unstable, ... }@inputs:
    let
      overlay = final: prev:
        let
          unstablePkgs = import unstable { inherit (prev) system; config.allowUnfree = true; };
        in
        {
          unstable = unstablePkgs;
        };
      mkSystem = system: hostname:
        nixpkgs.lib.nixosSystem {
          modules = [
            # Setting the hostname
            { networking.hostName = hostname; }

            # Overlay, makes "nixpkgs.unstable" available
            { nixpkgs.overlays = [ overlay ]; }

            # General configuration (users, networking, sound, etc)
            ./modules/system/configuration.nix

            # Custom configuration for each host
            (./. + "/hosts/${hostname}/configuration.nix")

            # WSL
            nixos-wsl.nixosModules.default
            {
              wsl.enable = if hostname == "laptop" then true else false;
              wsl.defaultUser = "marcus";
            }

            # Home manager
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                extraSpecialArgs = { inherit inputs unstable; };
                # Home manager config (configures programs like firefox, zsh, etc)
                users.marcus = (./. + "/hosts/${hostname}/user.nix");
              };
            }
          ];
          specialArgs = {
            inherit inputs;
            channels = { inherit nixpkgs unstable; };
          };
        };
    in
    {
      nixosConfigurations = {
        laptop = mkSystem "x86_64-linux" "laptop";
        desktop = mkSystem "x86_64-linux" "desktop";
      };
    };
}
