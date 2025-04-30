{
  description = "NixOS configuration";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    # Unstable channel
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Snap
    nix-snapd.url = "github:nix-community/nix-snapd";
    nix-snapd.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager, for declaratively configure dotfiles
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland window manager
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    # Wezterm
    wezterm.url = "github:wez/wezterm?dir=nix";

    # Zen browser
    zen-browser.url = "github:marcustut/zen-browser-flake";
  };

  outputs = { home-manager, nixpkgs, nix-snapd, unstable, ... }@inputs:
    let
      overlay = final: prev:
        let
          unstablePkgs = import unstable { inherit (prev) system; config.allowUnfree = true; };
        in
        {
          unstable = unstablePkgs;
        };
      mkSystem = system: hostname: user:
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

            # Snap
            nix-snapd.nixosModules.default
            {
              services.snap.enable = true;
            }

            # Home manager
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                extraSpecialArgs = { inherit inputs unstable; };
                # Home manager config (configures programs like firefox, zsh, etc)
                users.${user} = (./. + "/hosts/${hostname}/user.nix");
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
        laptop = mkSystem "x86_64-linux" "laptop" "marcus";
        desktop = mkSystem "x86_64-linux" "desktop" "marcus";
        gateway = mkSystem "x86_64-linux" "gateway" "balaenaquant";
      };
    };
}
