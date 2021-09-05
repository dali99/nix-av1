{ lib
, fetchFromGitHub
, bazel_3
, buildBazelPackage
, git
}:

buildBazelPackage rec {
  pname = "visqol";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "visqol";
    rev = "v${version}";
    sha256 = "1lsqn2v56ayb45vvzmiykb7qxxiwf7w4pdwynjx7j0s72kizjzch";
  };

  bazel = bazel_3;
  bazelTarget = ":visqol";

  nativeBuildInputs = [
    git
  ];

  removeRulesCC = false;
  fetchAttrs = {
    sha256 = "0l6civ2grbbdp8rjpds0nzd6f1iicca32jw57yn3c94zkavxlxla";
  };

  bazelBuildFlags = [
    "-c opt"
  ];
  buildAttrs = {
    installPhase = ''
      install -Dm0755 bazel-bin/visqol $out/bin/visqol
    '';
  };
}