{ pkgs, ... }:

{
  xdg.configFile."fish/conf.d/00-home-manager-key-bindings.fish".text = ''
    status is-interactive || exit
    set -q fish_key_bindings; or set -g fish_key_bindings fish_default_key_bindings
  '';

  home.sessionVariables = {
    FZF_ALT_C_COMMAND = "fd --type d --hidden --follow --exclude .git";
    FZF_ALT_C_OPTS = "--preview 'tree -C {} | head -200'";
    FZF_CTRL_T_COMMAND = "fd --color=always --type f --hidden --follow --exclude .git";
    FZF_DEFAULT_COMMAND = "fd --color=always --type f --hidden --follow --exclude .git";
    FZF_DEFAULT_OPTS = "--ansi";
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
    interactiveShellInit = ''
      set -g fish_greeting
      fzf --fish | source
      zoxide init fish --cmd cd | source
    '';
    shellInitLast = ''
      status is-interactive; and fish_config theme choose catppuccin-mocha
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
    settings = {
      add_newline = false;
      palette = "catppuccin_mocha";
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

      palettes.catppuccin_mocha = {
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
    };
  };

  programs.lazygit = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "lg";
  };
}
