{
  imports = [
    ./options.nix
    ./keymaps.nix
    ./plugins
    ./commands.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    colorschemes = {
      # https://nix-community.github.io/nixvim/colorschemes/tokyonight/index.html
      tokyonight = {
        enable = true;
        settings = {
          # Like many other themes, this one has different styles, and you could load
          # any other, such as 'storm', 'moon', or 'day'.
          style = "night";
        };
      };
    };
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
  };
}
