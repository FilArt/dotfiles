{...}: {
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      auto-optimise-store = true;
      trusted-users = ["root" "@wheel"];
      experimental-features = ["nix-command" "flakes"];
    };
    # limit nix-build from consuming too much of resources
    daemonIOSchedClass = "idle";
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedPriority = 7;
  };
  nixpkgs.config.allowUnfree = true;
}
