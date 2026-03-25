{ pkgs, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    FZF_ALT_C_COMMAND = "fd --type d --hidden --follow --exclude .git";
    FZF_ALT_C_OPTS = "--preview 'tree -C {} | head -200'";
    FZF_CTRL_T_COMMAND = "fd --color=always --type f --hidden --follow --exclude .git";
    FZF_DEFAULT_COMMAND = "fd --color=always --type f --hidden --follow --exclude .git";
    FZF_DEFAULT_OPTS = "--ansi";
    MANPATH = "/usr/share/man";
    VISUAL = "nvim";
  };

  programs.fish = {
    enable = true;
    loginShellInit = ''
      set -gx EDITOR nvim
      set -gx VISUAL nvim
    '';
    plugins = [
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "catppuccin-fish";
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "fish";
          rev = "5fc5ae9c2ec22eb376cb03ce76f0d262a38960f3";
          hash = "sha256-3KNWYXfOMzZovdjwjBpjSH8cVlD4CO2QmQcCyQE4Dac=";
        };
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
      starship init fish | source
      fzf --fish | source
      zoxide init fish --cmd cd | source
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
      lg = "lazygit";
    };
  };
}
