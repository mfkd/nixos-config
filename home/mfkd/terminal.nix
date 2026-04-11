{ lib, pkgs, ... }:

let
  mkBtopConfig =
    theme: ''
      color_theme = "${theme}"
      theme_background = True
    '';

  btopCatppuccinLatteTheme = ''
    # Main background, empty for terminal default, need to be empty if you want transparent background
    theme[main_bg]="#eff1f5"

    # Main text color
    theme[main_fg]="#4c4f69"

    # Title color for boxes
    theme[title]="#4c4f69"

    # Highlight color for keyboard shortcuts
    theme[hi_fg]="#1e66f5"

    # Background color of selected item in processes box
    theme[selected_bg]="#bcc0cc"

    # Foreground color of selected item in processes box
    theme[selected_fg]="#1e66f5"

    # Color of inactive/disabled text
    theme[inactive_fg]="#8c8fa1"

    # Color of text appearing on top of graphs, i.e uptime and current network graph scaling
    theme[graph_text]="#dc8a78"

    # Background color of the percentage meters
    theme[meter_bg]="#bcc0cc"

    # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
    theme[proc_misc]="#dc8a78"

    # CPU, Memory, Network, Proc box outline colors
    theme[cpu_box]="#8839ef" #Mauve
    theme[mem_box]="#40a02b" #Green
    theme[net_box]="#e64553" #Maroon
    theme[proc_box]="#1e66f5" #Blue

    # Box divider line and small boxes line color
    theme[div_line]="#9ca0b0"

    # Temperature graph color (Green -> Yellow -> Red)
    theme[temp_start]="#40a02b"
    theme[temp_mid]="#df8e1d"
    theme[temp_end]="#d20f39"

    # CPU graph colors (Teal -> Lavender)
    theme[cpu_start]="#179299"
    theme[cpu_mid]="#209fb5"
    theme[cpu_end]="#7287fd"

    # Mem/Disk free meter (Mauve -> Lavender -> Blue)
    theme[free_start]="#8839ef"
    theme[free_mid]="#7287fd"
    theme[free_end]="#1e66f5"

    # Mem/Disk cached meter (Sapphire -> Lavender)
    theme[cached_start]="#209fb5"
    theme[cached_mid]="#1e66f5"
    theme[cached_end]="#7287fd"

    # Mem/Disk available meter (Peach -> Red)
    theme[available_start]="#fe640b"
    theme[available_mid]="#e64553"
    theme[available_end]="#d20f39"

    # Mem/Disk used meter (Green -> Sky)
    theme[used_start]="#40a02b"
    theme[used_mid]="#179299"
    theme[used_end]="#04a5e5"

    # Download graph colors (Peach -> Red)
    theme[download_start]="#fe640b"
    theme[download_mid]="#e64553"
    theme[download_end]="#d20f39"

    # Upload graph colors (Green -> Sky)
    theme[upload_start]="#40a02b"
    theme[upload_mid]="#179299"
    theme[upload_end]="#04a5e5"

    # Process box color gradient for threads, mem and cpu usage (Sapphire -> Mauve)
    theme[process_start]="#209fb5"
    theme[process_mid]="#7287fd"
    theme[process_end]="#8839ef"
  '';

  btopCatppuccinMochaTheme = ''
    # Main background, empty for terminal default, need to be empty if you want transparent background
    theme[main_bg]="#1e1e2e"

    # Main text color
    theme[main_fg]="#cdd6f4"

    # Title color for boxes
    theme[title]="#cdd6f4"

    # Highlight color for keyboard shortcuts
    theme[hi_fg]="#89b4fa"

    # Background color of selected item in processes box
    theme[selected_bg]="#45475a"

    # Foreground color of selected item in processes box
    theme[selected_fg]="#89b4fa"

    # Color of inactive/disabled text
    theme[inactive_fg]="#7f849c"

    # Color of text appearing on top of graphs, i.e uptime and current network graph scaling
    theme[graph_text]="#f5e0dc"

    # Background color of the percentage meters
    theme[meter_bg]="#45475a"

    # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
    theme[proc_misc]="#f5e0dc"

    # CPU, Memory, Network, Proc box outline colors
    theme[cpu_box]="#cba6f7" #Mauve
    theme[mem_box]="#a6e3a1" #Green
    theme[net_box]="#eba0ac" #Maroon
    theme[proc_box]="#89b4fa" #Blue

    # Box divider line and small boxes line color
    theme[div_line]="#6c7086"

    # Temperature graph color (Green -> Yellow -> Red)
    theme[temp_start]="#a6e3a1"
    theme[temp_mid]="#f9e2af"
    theme[temp_end]="#f38ba8"

    # CPU graph colors (Teal -> Lavender)
    theme[cpu_start]="#94e2d5"
    theme[cpu_mid]="#74c7ec"
    theme[cpu_end]="#b4befe"

    # Mem/Disk free meter (Mauve -> Lavender -> Blue)
    theme[free_start]="#cba6f7"
    theme[free_mid]="#b4befe"
    theme[free_end]="#89b4fa"

    # Mem/Disk cached meter (Sapphire -> Lavender)
    theme[cached_start]="#74c7ec"
    theme[cached_mid]="#89b4fa"
    theme[cached_end]="#b4befe"

    # Mem/Disk available meter (Peach -> Red)
    theme[available_start]="#fab387"
    theme[available_mid]="#eba0ac"
    theme[available_end]="#f38ba8"

    # Mem/Disk used meter (Green -> Sky)
    theme[used_start]="#a6e3a1"
    theme[used_mid]="#94e2d5"
    theme[used_end]="#89dceb"

    # Download graph colors (Peach -> Red)
    theme[download_start]="#fab387"
    theme[download_mid]="#eba0ac"
    theme[download_end]="#f38ba8"

    # Upload graph colors (Green -> Sky)
    theme[upload_start]="#a6e3a1"
    theme[upload_mid]="#94e2d5"
    theme[upload_end]="#89dceb"

    # Process box color gradient for threads, mem and cpu usage (Sapphire -> Mauve)
    theme[process_start]="#74c7ec"
    theme[process_mid]="#b4befe"
    theme[process_end]="#cba6f7"
  '';
in

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

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_mocha";
      theme_background = true;
    };
    themes = {
      catppuccin_latte = btopCatppuccinLatteTheme;
      catppuccin_mocha = btopCatppuccinMochaTheme;
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

  xdg.configFile."btop/btop-dark.conf".text = mkBtopConfig "catppuccin_mocha";
  xdg.configFile."btop/btop-light.conf".text = mkBtopConfig "catppuccin_latte";
}
