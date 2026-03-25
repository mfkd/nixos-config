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
    tree
    unzip
    yazi
    zoxide
  ];
}
