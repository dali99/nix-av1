let
  pkgs = import <nixos-unstable> {};
in
rec {
    libaom = pkgs.callPackage ./pkgs/libaom {};
    visqol = pkgs.callPackage ./pkgs/visqol {};
    bopus = pkgs.callPackage ./pkgs/bopus { visqol = visqol; };
    ffmpeg = pkgs.ffmpeg.override { libaomSupport = true; libaom = libaom; };
}
