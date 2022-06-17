{
  description = "Flake providing aom-av1-psy";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/826794479e937f70ee2dad3d5cac38d3a0a5cb45;
  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.aom-av1-psy.url = "github:/BlueSwordM/aom-av1-psy/6fa36a27755a2d39dca9626a7b4e73bab7a374ad";
  inputs.aom-av1-psy.flake = false;

  outputs = { self, nixpkgs, flake-utils, ... }@inputs: 
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.aom-av1-psy = (pkgs.libaom.overrideAttrs (old: {
          pname = "aom-av1-psy";
          version = "unstable";
          src = inputs.aom-av1-psy;
        })).override { enableButteraugli = true; };

        apps.aomenc-psy = {
          type = "app";
          program = "${self.packages.${system}.aom-av1-psy.bin}/bin/aomenc";
        };

        hydraJobs.aom-av1-psy = self.packages.${system}.aom-av1-psy;
        
        
        
        packages.visqol = pkgs.callPackage ./pkgs/visqol { };
        packages.bopus = pkgs.callPackage ./pkgs/bopus { visqol = self.packages.${system}.visqol; };
        
        packages.ffmpeg-static-dav1d = pkgs.ffmpeg-full.override { dav1d = pkgs.pkgsStatic.dav1d; };
        packages.mpv-static-dav1d = pkgs.wrapMpv (pkgs.mpv-unwrapped.override { ffmpeg = self.packages.${system}.ffmpeg-static-dav1d; }) { };
      }
    );
}
