{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    code-insiders.url = "github:iosmanthus/code-insiders-flake";
    hyprland.url = "github:hyprwm/Hyprland";
    nix-gaming.url = "github:fufexan/nix-gaming";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    inherit (self) outputs;
  in {
    formatter.${system} = pkgs.alejandra;
    packages.${system} = pkgs.callPackage ./packages {};
    nixosConfigurations = {
      # FIXME replace with your hostname
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};

        # > Our main nixos configuration file <
        modules = [./system/configuration.nix];
      };
    };
    homeConfigurations."sakurafrost225" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [./home];
      extraSpecialArgs = {inherit inputs outputs;};
    };
  };
}
