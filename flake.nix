{
  description = "Flake providing aom-av1-psy";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/staging-next";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.aom-av1-psy.url = "github:/BlueSwordM/aom-av1-psy/full_build-alpha-4";
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
      let pkgs = import nixpkgs { overlays = [ self.overlay ]; inherit system; };
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
