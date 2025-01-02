# https://nix.dev/tutorials/nixos/building-and-running-docker-images.html

{ pkgs ? import <nixpkgs> { }
, pkgsLinux ? import <nixpkgs> { system = "x86_64-linux"; }
}:

pkgs.dockerTools.buildImage {
  name = "nixos-base";
  config = {
    Cmd = [ "${pkgsLinux.bash}/bin/bash" ];
  };
}
