{ pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    codex
    eza
    fastfetch
    fd
    fzf
    go
    gopls
    htop
    jq
    ripgrep
    tmux
    tree
    yazi
    zoxide
  ];
}
