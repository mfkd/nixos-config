{
  xdg.configFile."git/delta.gitconfig".text = ''
    [interactive]
        diffFilter = delta --color-only

    [merge]
        conflictStyle = zdiff3

    [delta]
        features = delta-base

    [delta "delta-base"]
        line-numbers = true
        navigate = true

    [delta "catppuccin-dark"]
        dark = true
        syntax-theme = Catppuccin Mocha

    [delta "catppuccin-light"]
        light = true
        syntax-theme = Catppuccin Latte
  '';

  programs.git = {
    enable = true;
    signing.format = "openpgp";
    settings = {
      alias = {
        br = "branch";
        ci = "commit";
        co = "checkout";
        di = "diff";
        st = "status -sb";
      };
      core.pager = "delta";
      credential.helper = "cache --timeout=7200";
      push.autoSetupRemote = true;
      safe.directory = "/etc/nixos";
      user = {
        email = "mattkfd@gmail.com";
        name = "mfkd";
      };
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
      prompt = "enabled";
      prefer_editor_prompt = "disabled";
      color_labels = "disabled";
      accessible_colors = "disabled";
      accessible_prompter = "disabled";
      spinner = "enabled";
      aliases.co = "pr checkout";
    };
  };

  home.file.".gitconfig".text = ''
    # Managed by Home Manager.
    # Git settings live in ~/.config/git/config.

    [include]
      path = ~/.config/git/delta.gitconfig
  '';
}
