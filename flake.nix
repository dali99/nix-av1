{
  description = "Flake providing aom-av1-psy";

  nixConfig.extra-substituters = ["https://cache.dodsorf.as"];
  nixConfig.exta-trusted-public-keys = "cache.dodsorf.as:FYKGadXTyI2ax8mirBTOjEqS/8PZKAWxiJVOBjESQXc=";

  inputs.nixpkgs.url = "github:Dali99/nixpkgs/libaom_static";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.aom-av1-psy.url = "github:/BlueSwordM/aom-av1-psy/full_build-alpha-4";
  inputs.aom-av1-psy.flake = false;

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
  let
    libaom-psy-d = pkgs: pkgs.libaom.overrideAttrs (old: {
      pname = "aom-av1-psy";
      version = "unstable";
      src = inputs.aom-av1-psy;
    });
  in
    {
      overlay = final: prev: {
        libaom-psy = libaom-psy-d prev;
      };
    }
    // flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { overlays = [ self.overlay ]; inherit system; };
      in {
        packages.libaom-psy = pkgs.libaom-psy;
        apps.aomenc-psy = {
          type = "app";
          program = "${self.packages.${system}.libaom-psy.bin}/bin/aomenc";
        };

        hydraJobs.libaom-psy = self.packages.${system}.libaom-psy;
        packages.libaom-psy-static = pkgs.pkgsStatic.libaom-psy;
        hydraJobs.libaom-psy-static = self.packages.${system}.libaom-psy-static;
        
                        
        packages.visqol = pkgs.callPackage ./pkgs/visqol { };
        packages.bopus = pkgs.callPackage ./pkgs/bopus { visqol = self.packages.${system}.visqol; };
        
        packages.ffmpeg-static-dav1d = pkgs.ffmpeg-full.override { dav1d = pkgs.pkgsStatic.dav1d; };
        packages.mpv-static-dav1d = pkgs.wrapMpv (pkgs.mpv-unwrapped.override { ffmpeg = self.packages.${system}.ffmpeg-static-dav1d; }) { };        
      }
    );
}
