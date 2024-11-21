{ ... }: {
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
  nixpkgs.config.allowUnfree = true;
}
