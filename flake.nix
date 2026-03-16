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

    todoart-api = {
      url = "github:FilArt/todoart";
      flake = false;
    };

    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
    opencode.url = "github:anomalyco/opencode";
    devenv.url = "github:cachix/devenv";

    autofirma-nix.url = "github:nix-community/autofirma-nix";
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    disko,
    catppuccin,
    helix,
    autofirma-nix,
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

        autofirma-nix.nixosModules.default
      ];
    };

    nixosConfigurations.archie = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      modules = [
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        {
          home-manager.users.archie = {
            imports = [
              ./hosts/archie/home.nix
            ];
          };
          home-manager.extraSpecialArgs = {inherit inputs;};
        }
        ./hosts/archie
      ];
    };
  };
}
