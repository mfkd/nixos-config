{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bubblewrap
    curl
    vim
  ];
}
