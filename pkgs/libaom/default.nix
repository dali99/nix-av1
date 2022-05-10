{
    lib, stdenv, fetchgit, yasm, perl, cmake, pkg-config, python3
    , libjxl, libvmaf
}:

stdenv.mkDerivation rec {
  pname = "libaom";
  version = "unstable-2021-09-03";

  src = fetchgit {
    url = "https://aomedia.googlesource.com/aom";
    rev = "83af7beabbac5d4a5921446a3ff2c4225e79396f";
    sha256 = "18jagg6x9zb50qhajb68qzyyj7qy264i2hdfqpbnz05g4a56nah2";
  };

  nativeBuildInputs = [
    yasm perl cmake pkg-config python3
  ];

#  buildInputs = [
#      libjxl
#      libvmaf
#  ];

  preConfigure = ''
    # build uses `git describe` to set the build version
    cat > $NIX_BUILD_TOP/git << "EOF"
    #!${stdenv.shell}
    echo v3.1.2-${src.rev}
    EOF
    chmod +x $NIX_BUILD_TOP/git
    export PATH=$NIX_BUILD_TOP:$PATH
  '';

  # Configuration options:
  # https://aomedia.googlesource.com/aom/+/refs/heads/master/build/cmake/aom_config_defaults.cmake

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DENABLE_TESTS=OFF"
    "-DCONFIG_TUNE_BUTTERAUGLI=1"
    "-DCONFIG_TUNE_VMAF=1"
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # CPU detection isn't supported on Darwin and breaks the aarch64-darwin build:
    "-DCONFIG_RUNTIME_CPU_DETECT=0"
  ];

  postFixup = ''
    moveToOutput lib/libaom.a "$static"
  '';

  outputs = [ "out" "bin" "dev" "static" ];

  meta = with lib; {
    description = "Alliance for Open Media AV1 codec library";
    longDescription = ''
      Libaom is the reference implementation of the AV1 codec from the Alliance
      for Open Media. It contains an AV1 library as well as applications like
      an encoder (aomenc) and a decoder (aomdec).
    '';
    homepage    = "https://aomedia.org/av1-features/get-started/";
    changelog   = "https://aomedia.googlesource.com/aom/+/refs/tags/v${version}/CHANGELOG";
    maintainers = with maintainers; [ primeos kiloreux ];
    platforms   = platforms.all;
    license = licenses.bsd2;
  };
}
