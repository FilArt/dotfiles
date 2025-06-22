{...}: {
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      auto-optimise-store = true;
      allowed-users = ["@wheel"];
      trusted-users = ["root" "@wheel"];
      commit-lockfile-summary = "chore: Update flake.lock";
      experimental-features = ["nix-command" "flakes"];
      builders-use-substitutes = true;

      accept-flake-config = true;
      keep-derivations = true;
      keep-outputs = true;
      warn-dirty = false;
    };
    # limit nix-build from consuming too much of resources
    daemonIOSchedClass = "idle";
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedPriority = 7;
  };
  nixpkgs.config.allowUnfree = true;
}
