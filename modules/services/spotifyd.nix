{ pkgs, ... }:

{
  hardware.alsa = {
    enable = true;
    defaultDevice.playback = "plughw:CARD=E50,DEV=0";
  };

  services.spotifyd = {
    enable = true;
    settings.global = {
      device_name = "nixos";
      device_type = "speaker";
      backend = "alsa";
      device = "plughw:CARD=E50,DEV=0";
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

