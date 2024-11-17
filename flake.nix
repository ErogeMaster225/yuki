{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    zen-browser.url = "github:ch4og/zen-browser-flake";
    code-insiders.url = "github:iosmanthus/code-insiders-flake";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      inherit (self) outputs;
    in {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
      nixosConfigurations = {
        # FIXME replace with your hostname
        nixos = nixpkgs.lib.nixosSystem rec {
          specialArgs = { inherit inputs outputs; };

          # > Our main nixos configuration file <
          modules = [
            ./nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = [
                inputs.neovim-nightly-overlay.overlays.default
              ]; # Pass overlays to nixpkgs
            }
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.sakurafrost225 = import ./home.nix;
              home-manager.extraSpecialArgs = specialArgs;
            }
          ];
        };
      };
    };
}