{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
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
    inputs.hunk.packages.${pkgs.stdenv.hostPlatform.system}.hunk
  ];
}
