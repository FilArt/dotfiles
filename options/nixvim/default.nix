{
  imports = [
    ./options.nix
    ./keymaps.nix
    ./plugins
  ];

  programs.nixvim = {
    enable = true;
    colorschemes.base16.enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;

    extraConfigLua = ''
      require('pqf').setup()
    '';

    extraConfigLuaPost = ''
      -- vim: ts=2 sts=2 sw=2 et
    '';
  };
}
