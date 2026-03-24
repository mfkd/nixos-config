{ lib, pkgs, ... }:

{
  programs.bat = {
    enable = true;
    config.theme = "Catppuccin Mocha";
    themes = {
      "Catppuccin Frappe" = {
        src = ./files/bat/themes;
        file = "Catppuccin Frappe.tmTheme";
      };
      "Catppuccin Latte" = {
        src = ./files/bat/themes;
        file = "Catppuccin Latte.tmTheme";
      };
      "Catppuccin Macchiato" = {
        src = ./files/bat/themes;
        file = "Catppuccin Macchiato.tmTheme";
      };
      "Catppuccin Mocha" = {
        src = ./files/bat/themes;
        file = "Catppuccin Mocha.tmTheme";
      };
    };
  };

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      command = "${pkgs.fish}/bin/fish --login --interactive";
      "shell-integration" = "fish";
      theme = "dark:Catppuccin Mocha,light:Catppuccin Latte";
    };
  };

  home.file.".tmux.conf".text =
    lib.replaceStrings
      [ "run ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux" ]
      [ "run-shell ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux" ]
      (builtins.readFile ./files/tmux.conf);
}
