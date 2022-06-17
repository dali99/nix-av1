{
  description = "Flake providing aom-av1-psy";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/397724176b474080a09422fdc29d3fc85cd43f2a";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.aom-av1-psy.url = "github:/BlueSwordM/aom-av1-psy/6fa36a27755a2d39dca9626a7b4e73bab7a374ad";
  inputs.aom-av1-psy.flake = false;

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
  let
    aom-av1-psy = pkgs: (pkgs.libaom.overrideAttrs (old: {
      pname = "aom-av1-psy";
      version = "unstable";
      src = inputs.aom-av1-psy;
    })).override { enableButteraugli = true; };
  in
    {
      overlay = final: prev: {
        libaom-psy = aom-av1-psy prev;
      };
    }
    // flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { overlays = [ self.overlay ]; config = { inherit system; }; };
      in {
        packages.aom-av1-psy = pkgs.libaom-psy;
        apps.aomenc-psy = {
          type = "app";
          program = "${self.packages.${system}.aom-av1-psy.bin}/bin/aomenc";
        };

        hydraJobs.aom-av1-psy = self.packages.${system}.aom-av1-psy;
        
                
        packages.visqol = pkgs.callPackage ./pkgs/visqol { };
        packages.bopus = pkgs.callPackage ./pkgs/bopus { visqol = self.packages.${system}.visqol; };
        
        packages.ffmpeg-static-dav1d = pkgs.ffmpeg-full.override { dav1d = pkgs.pkgsStatic.dav1d; };
        packages.mpv-static-dav1d = pkgs.wrapMpv (pkgs.mpv-unwrapped.override { ffmpeg = self.packages.${system}.ffmpeg-static-dav1d; }) { };
        
        
        packages.libaom-psy-static = (pkgs.pkgsStatic.libaom-psy.overrideAttrs (old: {
          cmakeFlags = [ "-DCMAKE_C_FLAGS_INITgs=-static" ];
          postInstall = "echo empty > $out/test";
        })).override { enableButteraugli = false; };
      }
    );
}
