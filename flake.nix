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
          version = "unstable-2022-05-24";
          src = pkgs.fetchFromGitHub {
            owner = "BlueSwordM";
            repo = "aom-av1-psy";
            rev = "fc18fec81dbcd1d80f19b78c2807ed433850203b";
            sha256 = "1xj6fxfr9y587xinw2gnc21waqsncpvv3prwll9pv373h22sf67x";
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
