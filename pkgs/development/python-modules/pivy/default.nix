{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pkgs,
  qtbase,
  qmake,
  soqt,
}:

buildPythonPackage rec {
  pname = "pivy";
  version = "0.6.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "coin3d";
    repo = "pivy";
    rev = "refs/tags/${version}";
    hash = "sha256-y72nzZAelyRDR2JS73/0jo2x/XiDZpsERPZV3gzIhAI=";
  };

  dontUseCmakeConfigure = true;

  nativeBuildInputs = with pkgs; [
    swig
    qmake
    cmake
  ];

  buildInputs =
    with pkgs;
    with xorg;
    [
      coin3d
      soqt
      qtbase
      libGLU
      libGL
      libXi
      libXext
      libSM
      libICE
      libX11
    ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${qtbase.dev}/include/QtCore"
    "-I${qtbase.dev}/include/QtGui"
    "-I${qtbase.dev}/include/QtOpenGL"
    "-I${qtbase.dev}/include/QtWidgets"
  ];

  dontUseQmakeConfigure = true;
  dontWrapQtApps = true;
  doCheck = false;

  postPatch = ''
    substituteInPlace distutils_cmake/CMakeLists.txt --replace \$'{SoQt_INCLUDE_DIRS}' \
      \$'{Coin_INCLUDE_DIR}'\;\$'{SoQt_INCLUDE_DIRS}'
  '';

  meta = with lib; {
    homepage = "https://github.com/coin3d/pivy/";
    description = "Python binding for Coin";
    license = licenses.bsd0;
    maintainers = with maintainers; [ gebner ];
  };
}
