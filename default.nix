let
  pkgs = import <nixos-unstable> {};
in
rec {
    libaom = pkgs.callPackage ./pkgs/libaom {};

    dav1d = pkgs.callPackage ./pkgs/dav1d {};

    visqol = pkgs.callPackage ./pkgs/visqol {};
    bopus = pkgs.callPackage ./pkgs/bopus { visqol = visqol; };

#    ffmpeg = pkgs.ffmpeg-full.override { libaom = pkgs.libaom; };

    ffmpeg-static-dav1d = pkgs.ffmpeg-full.override { dav1d = pkgs.pkgsStatic.dav1d; };
    mpv-static-dav1d = pkgs.wrapMpv (pkgs.mpv-unwrapped.override { ffmpeg = ffmpeg-static-dav1d; }) {};
}
