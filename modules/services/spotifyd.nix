{ pkgs, ... }:

{
  hardware.alsa = {
    enable = true;
    defaultDevice.playback = "sysdefault:CARD=PCH";
  };

  services.spotifyd = {
    enable = true;
    settings.global = {
      device_name = "nixos";
      device_type = "speaker";
      backend = "alsa";
      device = "sysdefault:CARD=PCH";
      volume_controller = "softvol";
      bitrate = 320;
      use_mpris = false;
      disable_discovery = false;
      zeroconf_port = 4070;
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ 5353 ];
    allowedTCPPorts = [ 4070 ];
  };

  environment.systemPackages = with pkgs; [
    alsa-utils
  ];

  users.users.mfkd.extraGroups = [ "audio" ];
}
