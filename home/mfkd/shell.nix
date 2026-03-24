{ ... }:

{
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
      d = "docker";
      g = "git";
      gs = "git status";
      k = "kubectl";
      l = "eza --icons -l --all --group-directories-first";
      lT = "eza --icons -T --git-ignore --level=4 --group-directories-first";
      ll = "eza --icons -l --all --all --group-directories-first --git";
      llt = "eza --icons -lT --git-ignore --level=2 --group-directories-first";
      ls = "eza --icons --group-directories-first";
      lt = "eza --icons -T --git-ignore --level=2 --group-directories-first";
      tree = "eza --icons -T";
    };
  };

  xdg.configFile = {
    "aliasrc".source = ./files/aliasrc;
    "fish/fish_plugins".source = ./files/fish/fish_plugins;
  };
}
