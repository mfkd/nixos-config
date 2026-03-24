{
  programs.git = {
    enable = true;
    signing.format = "openpgp";
    settings = {
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
  '';
}
