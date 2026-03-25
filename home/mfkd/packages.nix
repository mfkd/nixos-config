{ pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    codex
    eza
    fastfetch
    fd
    fzf
    gcc
    go
    gopls
    htop
    jq
    gnumake
    ripgrep
    tmux
    tree
    unzip
    yazi
    zoxide
  ];
}
