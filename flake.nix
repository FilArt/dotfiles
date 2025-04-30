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
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    nixvim,
    catppuccin,
    ...
  }: {
    nixosConfigurations.art = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        catppuccin.nixosModules.catppuccin

        home-manager.nixosModules.home-manager
        {
          home-manager.users.art = {
            imports = [
              ./home.nix
              catppuccin.homeManagerModules.catppuccin
            ];
          };
        }

        nixvim.nixosModules.nixvim

        ./configuration.nix
      ];
    };
  };
}
