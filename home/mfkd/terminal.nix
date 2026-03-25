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

  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    keyMode = "vi";
    historyLimit = 10000;
    escapeTime = 0;
    focusEvents = true;
    plugins = [ pkgs.tmuxPlugins.catppuccin ];
    extraConfig =
      lib.replaceStrings
        [
          "set-option -g default-shell /run/current-system/sw/bin/fish"
          "set -g status-keys vi"
          "set -g history-limit 10000"
          "set-window-option -g mode-keys vi"
          "set -sg escape-time 0"
          "set-option -g focus-events on"
          "bind-key r source-file ~/.tmux.conf"
          "run ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux"
        ]
        [
          ""
          ""
          ""
          ""
          ""
          ""
          "bind-key r source-file ~/.config/tmux/tmux.conf"
          ""
        ]
        (builtins.readFile ./files/tmux.conf);
  };
}
