{
  description = "A very basic flake";

  inputs.nixpkgs.url = github:Dali99/nixpkgs/libaom-tunes;

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.aom-av1-psy =
      with import nixpkgs { system = "x86_64-linux"; };
      libaom.overrideAttrs (old: {
        pname = "aom-av1-psy";
        version = "0.1.4";
        src = fetchFromGitHub {
          owner = "BlueSwordM";
          repo = "aom-av1-psy";
          rev = "full-aom-av1-psy-0.1.4";
          sha256 = "18agipmmyzkc6dj58x75w948k88364d734d1wbl60zz77gcrcd61";
        };
      });

    apps.x86_64-linux.aomenc = {
      type = "app";
      program = "${self.packages.x86_64-linux.aom-av1-psy.bin}/bin/aomenc";
    };
  };
}
