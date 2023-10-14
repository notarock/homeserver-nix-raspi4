{ lib, pkgs, ... }:
let
  authorizedKeys = pkgs.fetchurl {
    url = "https://github.com/notarock.keys";
    sha256 = "sha256-csW0RDWhKWyShy3/DzmMjRZTBS84VDdxecvpSgBTo6s=";
  };
in {

  systemd.network.enable = true;
  systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys =
    pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);

  virtualisation.oci-containers.containers.test.image = "library/hello-world";

  users.users.notarock = {
    isNormalUser = true;
    home = "/home/notarock";
    description = "Nickname for root";
    extraGroups = [ "docker" "video" ];
    shell = pkgs.zsh;
    initialPassword = "Ch4ngeMoi%%%";
    openssh.authorizedKeys.keys =
      pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
  };
}
