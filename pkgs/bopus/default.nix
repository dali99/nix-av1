{ lib, rustPlatform, fetchFromGitHub, makeWrapper, visqol }:

rustPlatform.buildRustPackage rec {
  pname = "bopus";
  version = "unstable-2021-08-09";

  src = fetchFromGitHub {
    owner = "master-of-zen";
    repo = pname;
    rev = "0080569232e4a5677e26ce5e8785e19ec9415346";
    sha256 = "1ymq002s0nyh0nwydip9cgbmjamgzdbsqcgs3dx2cxbli21a1q15";
  };

  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "12pngy4gmq8knlyaqsfbq2sk4y4s1sp7yapg1yjk482dnrvw1hj8";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/bopus --prefix PATH ":" "${visqol}/bin"
  '';

  meta = with lib; {
    description = "Searches for bitrate of OPUS that will result in desired quality. Quality of audio is asserted by Visqol.";
    homepage = "https://github.com/master-of-zen/BOPUS";
    license = licenses.unfree;
    maintainers = [ maintainers.dandellion ];
  };
}
