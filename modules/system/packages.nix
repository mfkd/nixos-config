{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    curl
    neovim
    vim
    lazygit
  ];
}
