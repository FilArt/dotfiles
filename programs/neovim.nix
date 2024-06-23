{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-lastplace
    ];
    extraPackages = with pkgs; [
      (python3.withPackages (ps: with ps; [
        ruff
        flake8
        pylint
      ]))
    ];
    extraPython3Packages = (ps: with ps; [
    ]);
  };
}
