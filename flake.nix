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
          version = "unstable-2022-05-27";
          src = pkgs.fetchFromGitHub {
            owner = "BlueSwordM";
            repo = "aom-av1-psy";
            rev = "2f86189644bcd3fcf37c8ec19bbf9394d9de7fc1";
            sha256 = "sha256-tjlYvma30Ht2m0IX2RGw1Mu8nXcd7RLhmP0CNfadJp0=";
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
