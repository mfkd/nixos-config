{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    curl
    fish
    gcc
    gnumake
    neovim
    unzip
    vim
  ];
}
