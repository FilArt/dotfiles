{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    helix.url = "github:helix-editor/helix"; # Or add /master for the latest dev version
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    nixvim,
    catppuccin,
    helix,
    ...
  }: {
    nixosConfigurations.art = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        catppuccin.nixosModules.catppuccin

        home-manager.nixosModules.home-manager
        {
          home-manager.users.art = {
            imports = [
              ./home.nix
              catppuccin.homeModules.catppuccin
            ];
          };
          home-manager.extraSpecialArgs = {inherit inputs;};
        }

        nixvim.nixosModules.nixvim

        ./configuration.nix
      ];

      specialArgs = {
        inherit inputs;
      };
    };
  };
}
