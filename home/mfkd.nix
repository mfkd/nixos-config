{ pkgs, ... }:

{
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    bat
    btop
    codex
    eza
    fastfetch
    fd
    fzf
    gh
    go
    gopls
    htop
    jq
    ripgrep
    starship
    tmux
    yazi
    zoxide
  ];

  programs.git = {
    enable = true;
    signing.format = "openpgp";
    settings = {
      user.name = "mfkd";
      user.email = "mattkfd@gmail.com";
      credential.helper = "cache --timeout=7200";
      push.autoSetupRemote = true;
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "eza -la";
      gs = "git status";
    };
    interactiveShellInit = ''
      set -g fish_greeting
      starship init fish | source
      fzf --fish | source
      zoxide init fish --cmd cd | source
    '';
  };

  programs.home-manager.enable = true;
}
