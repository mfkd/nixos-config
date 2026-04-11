{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    withRuby = true;
    initLua = builtins.readFile ./files/nvim/init.lua;
  };

  xdg.configFile."nvim/lazy-lock.json".source = ./files/nvim/lazy-lock.json;
}
