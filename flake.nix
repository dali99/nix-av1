{
  description = "Flake providing aom-av1-psy";

  inputs.nixpkgs.url = github:Dali99/nixpkgs/libaom-tunes;
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.aom-av1-psy = pkgs.libaom.overrideAttrs (old: {
          pname = "aom-av1-psy";
          version = "unstable-2022-06-03";
          src = pkgs.fetchFromGitHub {
            owner = "BlueSwordM";
            repo = "aom-av1-psy";
            rev = "6fa36a27755a2d39dca9626a7b4e73bab7a374ad";
            sha256 = "sha256-/FwdYqLzund/uHtOfyu2DhsqK09YWUifjV9sBOevDK4=";
          };
        });

        apps.aomenc = {
          type = "app";
          program = "${self.packages.${system}.aom-av1-psy.bin}/bin/aomenc";
        };

        hydraJobs.aom-av1-psy = self.packages.${system}.aom-av1-psy;
      }
    );
}
