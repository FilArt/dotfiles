{
  description = "NixOS configuration";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "path:/home/art/Projects/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    helix.url = "github:helix-editor/helix/master";

    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
    opencode.url = "github:anomalyco/opencode";
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    disko,
    catppuccin,
    helix,
    ...
  }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
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
              catppuccin.homeModules.catppuccin
            ];
          };
          home-manager.extraSpecialArgs = {inherit inputs;};
        }

        ./configuration.nix
      ];
    };

    nixosConfigurations.archie = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      modules = [
        disko.nixosModules.disko
        ./hosts/archie
      ];
    };
  };
}
