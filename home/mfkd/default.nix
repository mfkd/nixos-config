{
  imports = [
    ./packages.nix
    ./git.nix
    ./shell.nix
    ./terminal.nix
    ./editor.nix
  ];

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
