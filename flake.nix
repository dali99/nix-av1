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
          version = "0.1.4";
          src = pkgs.fetchFromGitHub {
            owner = "BlueSwordM";
            repo = "aom-av1-psy";
            rev = "full-aom-av1-psy-0.1.4";
            sha256 = "18agipmmyzkc6dj58x75w948k88364d734d1wbl60zz77gcrcd61";
          };
        });

        apps.aomenc = {
          type = "app";
          program = "${self.packages.${system}.aom-av1-psy.bin}/bin/aomenc";
        };    
      }
    );
}
