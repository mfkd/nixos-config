{ pkgs, ... }:

{
  home-manager.users.mfkd.imports = [ ../home/mfkd/desktop.nix ];

  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics.enable = true;
  };

  services = {
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "suspend";
      IdleAction = "ignore";
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    speechd.enable = false;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  fonts = {
    packages = [ pkgs.nerd-fonts.jetbrains-mono ];
    fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
      sansSerif = [ "JetBrainsMono Nerd Font" ];
    };
  };

  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;
    config.niri."org.freedesktop.impl.portal.AppChooser" = "gtk";
  };
}
