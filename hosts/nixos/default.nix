{ lib, ... }:

{
  imports =
    [
      ../../hardware-configuration.nix
      ../../modules/system/base.nix
      ../../modules/system/packages.nix
      ../../modules/services/ssh.nix
      ../../modules/services/power.nix
      ../../modules/users/mfkd.nix
    ]
    ++ lib.optionals (builtins.pathExists ../../local.nix) [
      ../../local.nix
    ];
}
