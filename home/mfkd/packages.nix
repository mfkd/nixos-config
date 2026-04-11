{ pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    codex
    delta
    eza
    fastfetch
    fd
    fzf
    gcc
    go
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
