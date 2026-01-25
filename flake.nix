{
  description = "bryllm's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, firefox-addons, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Import packages.nix as a simple list
      homePackages = import ./home/packages.nix { inherit pkgs; };
    in
    {
      nixosConfigurations = {
        dell-laptop = pkgs.lib.nixosSystem {
          system = system;

          specialArgs = { inherit zen-browser firefox-addons; };

          modules = [
            ./hosts/dell-laptop/configuration.nix

            # Home Manager module
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";

              # Import your home configuration and pass packages
              home-manager.users.bryllm = import ./home/default.nix {
                inherit pkgs zen-browser firefox-addons;
                packages = homePackages;
              };

              home-manager.extraSpecialArgs = { inherit zen-browser firefox-addons; };
            }
          ];
        };
      };
    };
}
