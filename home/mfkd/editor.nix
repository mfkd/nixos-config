{ pkgs, ... }:

let
  treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (parsers: with parsers; [
    bash
    c
    diff
    html
    lua
    luadoc
    markdown
    markdown_inline
    query
    vim
    vimdoc
  ]);
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    withRuby = true;
    extraPackages = with pkgs; [
      gopls
      lua-language-server
      pyright
      rust-analyzer
      stylua
    ];
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      conform-nvim
      gitsigns-nvim
      guess-indent-nvim
      lazydev-nvim
      mini-nvim
      nvim-lspconfig
      nvim-web-devicons
      plenary-nvim
      telescope-fzf-native-nvim
      telescope-nvim
      telescope-ui-select-nvim
      todo-comments-nvim
      which-key-nvim
      treesitter
    ];
    initLua = builtins.readFile ./files/nvim/init.lua;
  };

  xdg.configFile."nvim/.stylua.toml".source = ./files/nvim/.stylua.toml;
  xdg.configFile."nvim/after/lsp/lua_ls.lua".source = ./files/nvim/after/lsp/lua_ls.lua;
  xdg.configFile."nvim/after/plugin/setup.lua".source = ./files/nvim/after/plugin/setup.lua;
  xdg.configFile."nvim/lua/config/lsp.lua".source = ./files/nvim/lua/config/lsp.lua;
}
