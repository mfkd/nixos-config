{ ... }:

{
  # Copy this file to local.nix and replace the placeholder key.
  users.users.mfkd.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINH0Ta65DJB3YOIOX82gz5hophF5uKoGJbzUAnmIsoCc mattkfd@gmail.com"
  ];

  # If you need a temporary password for local console login, uncomment this.
  # SSH password login is disabled in configuration.nix.
  # users.users.mfkd.initialPassword = "change-me";
}
