# https://nix.dev/tutorials/nixos/building-and-running-docker-images.html
# https://ryantm.github.io/nixpkgs/builders/images/dockertools/

{ pkgs ? import <nixpkgs> { }
, pkgsLinux ? import <nixpkgs> { system = "x86_64-linux"; }
}:

pkgs.dockerTools.buildImage {
  name = "nixos-base";
  tag = "latest";

  copyToRoot = pkgs.buildEnv {
    name = "image-root";
    paths = with pkgs; [
      bash
      coreutils-full
      nix
      tmux
    ];
    pathsToLink = [
      "/bin"
    ];
  };

  runAsRoot = ''
  #!${pkgs.runtimeShell}
  mkdir -pv /workdir
  '';

  config = {
    Cmd = [ "${pkgsLinux.bash}/bin/bash" ];
    WorkingDir = "/workdir";
    Volumes = { "/workdir" = {}; };
  };
}
