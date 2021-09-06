let
  pkgs = import <nixos-unstable> {};
in
rec {
    libaom = pkgs.callPackage ./pkgs/libaom {};
    visqol = pkgs.callPackage ./pkgs/visqol {};
    bopus = pkgs.callPackage ./pkgs/bopus { visqol = visqol; };
    ffmpeg = pkgs.ffmpeg.override { libaomSupport = true; libaom = pkgs.libaom; };
    ffmpeg_static_dav1d = pkgs.ffmpeg-full.override { dav1d = pkgs.pkgsStatic.dav1d; };
    mpv_static_dav1d = pkgs.wrapMpv (pkgs.mpv-unwrapped.override { ffmpeg = ffmpeg_static_dav1d; }) {};
}
