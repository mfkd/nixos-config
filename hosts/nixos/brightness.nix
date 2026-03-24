{ ... }:

let
  device = "intel_backlight";
  lowBrightness = 42;
in
{
  systemd.services.low-brightness = {
    description = "Set laptop backlight to a low level";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-backlight@backlight:${device}.service" ];
    unitConfig.ConditionPathExists = "/sys/class/backlight/${device}/brightness";
    serviceConfig.Type = "oneshot";
    script = ''
      echo ${toString lowBrightness} > /sys/class/backlight/${device}/brightness
    '';
  };
}
