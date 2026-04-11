{ pkgs, ... }:

let
  tomlFormat = pkgs.formats.toml { };
  yamlFormat = pkgs.formats.yaml { };

  starshipDarkPalette = {
    rosewater = "#f5e0dc";
    flamingo = "#f2cdcd";
    pink = "#f5c2e7";
    mauve = "#cba6f7";
    red = "#f38ba8";
    maroon = "#eba0ac";
    peach = "#fab387";
    yellow = "#f9e2af";
    green = "#a6e3a1";
    teal = "#94e2d5";
    sky = "#89dceb";
    sapphire = "#74c7ec";
    blue = "#89b4fa";
    lavender = "#b4befe";
    text = "#cdd6f4";
    subtext1 = "#bac2de";
    subtext0 = "#a6adc8";
    overlay2 = "#9399b2";
    overlay1 = "#7f849c";
    overlay0 = "#6c7086";
    surface2 = "#585b70";
    surface1 = "#45475a";
    surface0 = "#313244";
    base = "#1e1e2e";
    mantle = "#181825";
    crust = "#11111b";
  };

  starshipLightPalette = {
    rosewater = "#dc8a78";
    flamingo = "#dd7878";
    pink = "#ea76cb";
    mauve = "#8839ef";
    red = "#d20f39";
    maroon = "#e64553";
    peach = "#fe640b";
    yellow = "#df8e1d";
    green = "#40a02b";
    teal = "#179299";
    sky = "#04a5e5";
    sapphire = "#209fb5";
    blue = "#1e66f5";
    lavender = "#7287fd";
    text = "#4c4f69";
    subtext1 = "#5c5f77";
    subtext0 = "#6c6f85";
    overlay2 = "#7c7f93";
    overlay1 = "#8c8fa1";
    overlay0 = "#9ca0b0";
    surface2 = "#acb0be";
    surface1 = "#bcc0cc";
    surface0 = "#ccd0da";
    base = "#eff1f5";
    mantle = "#e6e9ef";
    crust = "#dce0e8";
  };

  starshipCommonSettings = {
    add_newline = false;
    scan_timeout = 10;
    character = {
      success_symbol = "[❯](peach)";
      error_symbol = "[❯](peach)";
      vimcmd_symbol = "[❮](subtext1)";
    };
    directory = {
      truncation_length = 4;
      style = "bold lavender";
    };
    git_branch.style = "bold mauve";
  };

  starshipDarkConfig = tomlFormat.generate "starship-dark.toml" (starshipCommonSettings // {
    palette = "catppuccin_mocha";
    palettes.catppuccin_mocha = starshipDarkPalette;
  });

  starshipLightConfig = tomlFormat.generate "starship-light.toml" (starshipCommonSettings // {
    palette = "catppuccin_latte";
    palettes.catppuccin_latte = starshipLightPalette;
  });

  ezaDarkTheme = yamlFormat.generate "eza-dark-theme.yml" {
    colourful = true;
    filekinds = {
      normal.foreground = "#cdd6f4";
      directory.foreground = "#cba6f7";
      symlink.foreground = "#89b4fa";
      pipe.foreground = "#bac2de";
      block_device.foreground = "#eba0ac";
      char_device.foreground = "#eba0ac";
      socket.foreground = "#bac2de";
      special.foreground = "#cba6f7";
      executable.foreground = "#a6e3a1";
      mount_point.foreground = "#94e2d5";
    };
    perms = {
      user_read = { foreground = "#f38ba8"; is_bold = true; };
      user_write = { foreground = "#f9e2af"; is_bold = true; };
      user_execute_file = { foreground = "#a6e3a1"; is_bold = true; };
      user_execute_other = { foreground = "#a6e3a1"; is_bold = true; };
      group_read.foreground = "#f38ba8";
      group_write.foreground = "#f9e2af";
      group_execute.foreground = "#a6e3a1";
      other_read.foreground = "#f38ba8";
      other_write.foreground = "#f9e2af";
      other_execute.foreground = "#a6e3a1";
      special_user_file.foreground = "#cba6f7";
      special_other.foreground = "#7f849c";
      attribute.foreground = "#9399b2";
    };
    size = {
      major.foreground = "#a6adc8";
      minor.foreground = "#89dceb";
      number_byte.foreground = "#bac2de";
      number_kilo.foreground = "#a6adc8";
      number_mega.foreground = "#89b4fa";
      number_giga.foreground = "#cba6f7";
      number_huge.foreground = "#cba6f7";
      unit_byte.foreground = "#a6adc8";
      unit_kilo.foreground = "#89dceb";
      unit_mega.foreground = "#cba6f7";
      unit_giga.foreground = "#cba6f7";
      unit_huge.foreground = "#94e2d5";
    };
    users = {
      user_you.foreground = "#cdd6f4";
      user_root.foreground = "#f38ba8";
      user_other.foreground = "#eba0ac";
      group_yours.foreground = "#a6adc8";
      group_other.foreground = "#9399b2";
      group_root.foreground = "#f38ba8";
    };
    links = {
      normal.foreground = "#89b4fa";
      multi_link_file.foreground = "#89b4fa";
    };
    git = {
      new.foreground = "#a6e3a1";
      modified.foreground = "#f9e2af";
      deleted.foreground = "#eba0ac";
      renamed.foreground = "#94e2d5";
      typechange.foreground = "#f5c2e7";
      ignored.foreground = "#7f849c";
      conflicted.foreground = "#fab387";
    };
    git_repo = {
      branch_main.foreground = "#a6adc8";
      branch_other.foreground = "#cba6f7";
      git_clean.foreground = "#a6e3a1";
      git_dirty.foreground = "#eba0ac";
    };
    security_context = {
      colon.foreground = "#6c7086";
      user.foreground = "#7f849c";
      role.foreground = "#cba6f7";
      typ.foreground = "#585b70";
      range.foreground = "#cba6f7";
    };
    file_type = {
      image.foreground = "#f9e2af";
      video.foreground = "#f38ba8";
      music.foreground = "#a6e3a1";
      lossless.foreground = "#94e2d5";
      crypto.foreground = "#7f849c";
      document.foreground = "#cdd6f4";
      compressed.foreground = "#f5c2e7";
      temp.foreground = "#eba0ac";
      compiled.foreground = "#74c7ec";
      source.foreground = "#89b4fa";
    };
    punctuation.foreground = "#6c7086";
    date.foreground = "#f9e2af";
    inode.foreground = "#a6adc8";
    blocks.foreground = "#6c7086";
    header.foreground = "#cdd6f4";
    octal.foreground = "#94e2d5";
    flags.foreground = "#cba6f7";
    symlink_path.foreground = "#89dceb";
    control_char.foreground = "#74c7ec";
    broken_symlink.foreground = "#f38ba8";
    broken_path_overlay.foreground = "#585b70";
  };

  ezaLightTheme = yamlFormat.generate "eza-light-theme.yml" {
    colourful = true;
    filekinds = {
      normal.foreground = "#4c4f69";
      directory.foreground = "#8839ef";
      symlink.foreground = "#1e66f5";
      pipe.foreground = "#5c5f77";
      block_device.foreground = "#e64553";
      char_device.foreground = "#e64553";
      socket.foreground = "#5c5f77";
      special.foreground = "#8839ef";
      executable.foreground = "#40a02b";
      mount_point.foreground = "#179299";
    };
    perms = {
      user_read = { foreground = "#d20f39"; is_bold = true; };
      user_write = { foreground = "#df8e1d"; is_bold = true; };
      user_execute_file = { foreground = "#40a02b"; is_bold = true; };
      user_execute_other = { foreground = "#40a02b"; is_bold = true; };
      group_read.foreground = "#d20f39";
      group_write.foreground = "#df8e1d";
      group_execute.foreground = "#40a02b";
      other_read.foreground = "#d20f39";
      other_write.foreground = "#df8e1d";
      other_execute.foreground = "#40a02b";
      special_user_file.foreground = "#8839ef";
      special_other.foreground = "#8c8fa1";
      attribute.foreground = "#7c7f93";
    };
    size = {
      major.foreground = "#6c6f85";
      minor.foreground = "#04a5e5";
      number_byte.foreground = "#5c5f77";
      number_kilo.foreground = "#6c6f85";
      number_mega.foreground = "#1e66f5";
      number_giga.foreground = "#8839ef";
      number_huge.foreground = "#8839ef";
      unit_byte.foreground = "#6c6f85";
      unit_kilo.foreground = "#04a5e5";
      unit_mega.foreground = "#8839ef";
      unit_giga.foreground = "#8839ef";
      unit_huge.foreground = "#179299";
    };
    users = {
      user_you.foreground = "#4c4f69";
      user_root.foreground = "#d20f39";
      user_other.foreground = "#e64553";
      group_yours.foreground = "#6c6f85";
      group_other.foreground = "#7c7f93";
      group_root.foreground = "#d20f39";
    };
    links = {
      normal.foreground = "#1e66f5";
      multi_link_file.foreground = "#1e66f5";
    };
    git = {
      new.foreground = "#40a02b";
      modified.foreground = "#df8e1d";
      deleted.foreground = "#e64553";
      renamed.foreground = "#179299";
      typechange.foreground = "#ea76cb";
      ignored.foreground = "#8c8fa1";
      conflicted.foreground = "#fe640b";
    };
    git_repo = {
      branch_main.foreground = "#6c6f85";
      branch_other.foreground = "#8839ef";
      git_clean.foreground = "#40a02b";
      git_dirty.foreground = "#e64553";
    };
    security_context = {
      colon.foreground = "#9ca0b0";
      user.foreground = "#8c8fa1";
      role.foreground = "#8839ef";
      typ.foreground = "#acb0be";
      range.foreground = "#8839ef";
    };
    file_type = {
      image.foreground = "#df8e1d";
      video.foreground = "#d20f39";
      music.foreground = "#40a02b";
      lossless.foreground = "#179299";
      crypto.foreground = "#8c8fa1";
      document.foreground = "#4c4f69";
      compressed.foreground = "#ea76cb";
      temp.foreground = "#e64553";
      compiled.foreground = "#209fb5";
      source.foreground = "#1e66f5";
    };
    punctuation.foreground = "#9ca0b0";
    date.foreground = "#df8e1d";
    inode.foreground = "#6c6f85";
    blocks.foreground = "#9ca0b0";
    header.foreground = "#4c4f69";
    octal.foreground = "#179299";
    flags.foreground = "#8839ef";
    symlink_path.foreground = "#04a5e5";
    control_char.foreground = "#209fb5";
    broken_symlink.foreground = "#d20f39";
    broken_path_overlay.foreground = "#acb0be";
  };

  lazygitDarkTheme = yamlFormat.generate "lazygit-dark-theme.yml" {
    gui.theme = {
      activeBorderColor = [ "#cba6f7" "bold" ];
      inactiveBorderColor = [ "#a6adc8" ];
      optionsTextColor = [ "#89b4fa" ];
      selectedLineBgColor = [ "#313244" ];
      cherryPickedCommitBgColor = [ "#45475a" ];
      cherryPickedCommitFgColor = [ "#cba6f7" ];
      unstagedChangesColor = [ "#f38ba8" ];
      defaultFgColor = [ "#cdd6f4" ];
      searchingActiveBorderColor = [ "#f9e2af" ];
    };
    gui.authorColors."*" = "#b4befe";
  };

  lazygitLightTheme = yamlFormat.generate "lazygit-light-theme.yml" {
    gui.theme = {
      activeBorderColor = [ "#8839ef" "bold" ];
      inactiveBorderColor = [ "#6c6f85" ];
      optionsTextColor = [ "#1e66f5" ];
      selectedLineBgColor = [ "#ccd0da" ];
      cherryPickedCommitBgColor = [ "#bcc0cc" ];
      cherryPickedCommitFgColor = [ "#8839ef" ];
      unstagedChangesColor = [ "#d20f39" ];
      defaultFgColor = [ "#4c4f69" ];
      searchingActiveBorderColor = [ "#df8e1d" ];
    };
    gui.authorColors."*" = "#7287fd";
  };
in

{
  xdg.configFile."fish/conf.d/00-home-manager-key-bindings.fish".text = ''
    status is-interactive || exit
    set -q fish_key_bindings; or set -g fish_key_bindings fish_default_key_bindings
  '';
  xdg.configFile."fish/themes/catppuccin-latte.theme".text = ''
    # name: 'Catppuccin Latte'

    [light]
    # preferred_background: eff1f5
    fish_color_normal 4c4f69
    fish_color_autosuggestion 9ca0b0
    fish_color_command 1e66f5
    fish_color_comment 8c8fa1
    fish_color_cwd df8e1d
    fish_color_cwd_root
    fish_color_end fe640b
    fish_color_error d20f39
    fish_color_escape e64553
    fish_color_gray 9ca0b0
    fish_color_history_current
    fish_color_host 1e66f5
    fish_color_host_remote 40a02b
    fish_color_keyword 8839ef
    fish_color_operator ea76cb
    fish_color_option 40a02b
    fish_color_param dd7878
    fish_color_quote 40a02b
    fish_color_redirection ea76cb
    fish_color_search_match --background=ccd0da
    fish_color_selection --background=ccd0da
    fish_color_status d20f39
    fish_color_user 179299
    fish_color_valid_path
    fish_pager_color_completion 4c4f69
    fish_pager_color_description 9ca0b0
    fish_pager_color_prefix ea76cb
    fish_pager_color_progress 9ca0b0
    fish_pager_color_selected_background
  '';
  xdg.configFile."eza/dark/theme.yml".source = ezaDarkTheme;
  xdg.configFile."eza/light/theme.yml".source = ezaLightTheme;
  xdg.configFile."starship.toml".source = starshipDarkConfig;
  xdg.configFile."starship-dark.toml".source = starshipDarkConfig;
  xdg.configFile."starship-light.toml".source = starshipLightConfig;
  xdg.configFile."lazygit/dark/theme.yml".source = lazygitDarkTheme;
  xdg.configFile."lazygit/light/theme.yml".source = lazygitLightTheme;

  home.sessionVariables = {
    FZF_ALT_C_COMMAND = "fd --type d --hidden --follow --exclude .git --exclude node_modules --exclude target";
    FZF_ALT_C_OPTS = "--select-1 --exit-0 --preview 'eza --icons --tree --all --level=2 --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'";
    FZF_COMPLETION_OPTS = "--border --info=inline";
    FZF_CTRL_R_OPTS = "--color header:italic";
    FZF_CTRL_T_COMMAND = "fd --hidden --follow --exclude .git --exclude node_modules --exclude target";
    FZF_CTRL_T_OPTS = "--select-1 --exit-0 --preview 'if [ -d {} ]; then eza --icons --tree --all --level=2 --color=always {}; else bat -n --color=always --line-range :500 {}; fi' --bind 'ctrl-/:change-preview-window(down|hidden|)'";
    FZF_DEFAULT_COMMAND = "fd --color=always --type f --hidden --follow --exclude .git";
    FZF_DEFAULT_OPTS = "--ansi --height=40% --layout=reverse --border";
    FZF_DEFAULT_OPTS_BASE = "--ansi --height=40% --layout=reverse --border";
    MANPATH = "/usr/share/man";
  };

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
    ];
    preferAbbrs = true;
    functions."man-find" = {
      description = "Fuzzy-find a man page";
      body = ''
        set -l section 1
        if test (count $argv) -gt 0
          set section $argv[1]
        end

        set -l page (fd . $MANPATH/man$section -t f -x echo {/.} | fzf)
        if test -n "$page"
          man $page
        end
      '';
    };
    functions.btop = {
      description = "Launch btop with the current Catppuccin theme";
      body = ''
        set -l theme dark

        if set -q TERM_THEME
          switch $TERM_THEME
          case light
            set theme light
          case dark
            set theme dark
          end
        end

        ${pkgs.btop}/bin/btop --config ~/.config/btop/btop-$theme.conf $argv
      '';
    };
    functions."__set_fzf_theme" = {
      description = "Apply the current theme to fzf";
      body = ''
        set -l theme_opts

        switch $argv[1]
        case dark
          set theme_opts (string join -- ' ' \
            "--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8" \
            "--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC" \
            "--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8" \
            "--color=selected-bg:#45475A" \
            "--color=border:#6C7086,label:#CDD6F4")
        case light
          set theme_opts (string join -- ' ' \
            "--color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39" \
            "--color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78" \
            "--color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39" \
            "--color=selected-bg:#BCC0CC" \
            "--color=border:#9CA0B0,label:#4C4F69")
        case '*'
          echo "__set_fzf_theme: unsupported mode '$argv[1]'" >&2
          return 1
        end

        set -gx FZF_THEME_OPTS "$theme_opts"
        set -gx FZF_DEFAULT_OPTS (string join -- ' ' "$FZF_DEFAULT_OPTS_BASE" "$FZF_THEME_OPTS")
      '';
    };
    functions."__apply_theme" = {
      description = "Apply the requested terminal theme to the shell toolchain";
      body = ''
        set -l theme $argv[1]
        set -l lazygit_root ~/.config/lazygit

        switch $theme
        case light
          fish_config theme choose catppuccin-latte --color-theme=light
          set -gx BAT_THEME "Catppuccin Latte"
          set -gx DELTA_FEATURES "+catppuccin-light"
          set -gx EZA_CONFIG_DIR ~/.config/eza/light
          set -gx LG_CONFIG_FILE "$lazygit_root/config.yml,$lazygit_root/light/theme.yml"
          set -gx STARSHIP_CONFIG ~/.config/starship-light.toml
          __set_fzf_theme light
        case dark
          fish_config theme choose catppuccin-mocha --color-theme=dark
          set -gx BAT_THEME "Catppuccin Mocha"
          set -gx DELTA_FEATURES "+catppuccin-dark"
          set -gx EZA_CONFIG_DIR ~/.config/eza/dark
          set -gx LG_CONFIG_FILE "$lazygit_root/config.yml,$lazygit_root/dark/theme.yml"
          set -gx STARSHIP_CONFIG ~/.config/starship-dark.toml
          __set_fzf_theme dark
        case '*'
          echo "usage: theme <dark|light>"
          return 1
        end

        if set -q TMUX
          tmux set-environment -g TERM_THEME $theme >/dev/null 2>&1
        end
      '';
    };
    functions.theme = {
      description = "Persist and apply a terminal theme";
      body = ''
        if test (count $argv) -ne 1
          echo "usage: theme <dark|light>"
          return 1
        end

        switch $argv[1]
        case dark light
          set -Ux TERM_THEME $argv[1]
          __apply_theme $argv[1]
        case '*'
          echo "usage: theme <dark|light>"
          return 1
        end
      '';
    };
    functions.dark = {
      description = "Switch terminal tooling to the dark theme";
      body = ''
        theme dark
      '';
    };
    functions.light = {
      description = "Switch terminal tooling to the light theme";
      body = ''
        theme light
      '';
    };
    interactiveShellInit = ''
      set -g fish_greeting
      fzf --fish | source
      zoxide init fish --cmd cd | source
    '';
    shellInitLast = ''
      if status is-interactive
        set -q TERM_THEME; or set -Ux TERM_THEME dark
        __apply_theme $TERM_THEME
      end
    '';
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      by = "bat -l yaml";
      gs = "git status";
      l = "eza --icons -l --all --group-directories-first";
      lT = "eza --icons -T --git-ignore --level=4 --group-directories-first";
      ll = "eza --icons -l --all --all --group-directories-first --git";
      llt = "eza --icons -lT --git-ignore --level=2 --group-directories-first";
      ls = "eza --icons --group-directories-first";
      lt = "eza --icons -T --git-ignore --level=2 --group-directories-first";
      tree = "eza --icons -T";
    };
    shellAbbrs = {
      d = "docker";
      g = "git";
      k = "kubectl";
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.lazygit = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "lg";
    settings = {
      gui.nerdFontsVersion = "3";
      git.pagers = [
        {
          colorArg = "always";
          pager = "delta --paging=never";
        }
      ];
    };
  };
}
