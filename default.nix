let
  pkgs = import <nixos-unstable> {};
in
rec {
    libaom = pkgs.callPackage ./pkgs/libaom {};

    aom-av1-psy = (pkgs.libaom
      .override { enableButteraugli = true; enableVmaf = true;})
      .overrideAttrs (old: {
        pname = "aom-av1-psy";
        version = "0.1.2";
        src = pkgs.fetchFromGitHub {
          owner = "BlueSwordM";
          repo = "aom-av1-psy";
          rev = "full-aom-av1-psy-0.1.2";
          sha256 = "15767p33wpr6w7w7avi7rlf4b71947mczgqcsbakrhjhcfybzs61";
        };
      });

    dav1d = pkgs.callPackage ./pkgs/dav1d {};

    visqol = pkgs.callPackage ./pkgs/visqol {};
    bopus = pkgs.callPackage ./pkgs/bopus { visqol = visqol; };

#    ffmpeg = pkgs.ffmpeg-full.override { libaom = pkgs.libaom; };


    ffmpeg-static-dav1d = pkgs.ffmpeg-full.override { dav1d = pkgs.pkgsStatic.dav1d; };
    mpv-static-dav1d = pkgs.wrapMpv (pkgs.mpv-unwrapped.override { ffmpeg = ffmpeg-static-dav1d; }) {};
}
