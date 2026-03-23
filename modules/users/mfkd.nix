{ pkgs, ... }:

{
  users.users.mfkd = {
    isNormalUser = true;
    description = "mfkd";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [];
  };
}
