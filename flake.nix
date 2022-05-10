{
  description = "A very basic flake";

  inputs.nixpkgs.url = github:Dali99/nixpkgs/libaom-tunes;

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.aom-av1-psy =
      with import nixpkgs { system = "x86_64-linux"; };
      (libaom.override {enableButteraugli = true; enableVmaf = true;}).overrideAttrs (old: {
        pname = "aom-av1-psy";
        version = "0.1.2";
        src = fetchFromGitHub {
          owner = "BlueSwordM";
          repo = "aom-av1-psy";
          rev = "full-aom-av1-psy-0.1.2";
          sha256 = "15767p33wpr6w7w7avi7rlf4b71947mczgqcsbakrhjhcfybzs61";
        };
      });

    apps.x86_64-linux.aomenc = {
      type = "app";
      program = "${self.packages.x86_64-linux.aom-av1-psy.bin}/bin/aomenc";
    };
  };
}
