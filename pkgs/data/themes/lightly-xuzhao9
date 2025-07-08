{
  mkDerivation,
  lib,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  kdecoration,
  plasma-workspace,
  qtbase,
  qt5,
}:

mkDerivation rec {
  pname = "lightly-qt";
  version = "0.x";

  src = fetchFromGitHub {
    owner = "xuzhao9";
    repo = "Lightly";
    rev = "v${version}";
    sha256 = "UNKNOWN";
  };

  buildInputs = [
    kdecoration
    plasma-workspace
    qtbase
    qt5.qtx11extras
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  meta = with lib; {
    description = "Fork of breeze theme style that aims to be visually modern and minimalistic";
    mainProgram = "lightly-settings5";
    homepage = "https://github.com/xuzhao9/Lightly";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.pwoelfel ];
    platforms = platforms.all;
  };
}
