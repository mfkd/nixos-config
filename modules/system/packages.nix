{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bubblewrap
    curl
    powertop
    vim
  ];
}
