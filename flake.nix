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

    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, firefox-addons, claude-desktop, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        dell-laptop = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { 
            inherit zen-browser firefox-addons claude-desktop; 
          };

          modules = [
            ./hosts/dell-laptop/configuration.nix

            # Home Manager module
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";

              # Pass the inputs to home-manager
              home-manager.extraSpecialArgs = { 
                inherit zen-browser firefox-addons claude-desktop; 
              };

              # Import home configuration with zen module
              home-manager.users.bryllm = {
                imports = [
                  zen-browser.homeModules.twilight
                  ./home/default.nix
                ];
              };
            }
          ];
        };
      };
    };
}
