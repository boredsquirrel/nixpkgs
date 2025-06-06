{
  stdenv,
  lib,
  replaceVars,
  pkg-config,
  fetchurl,
  python3Packages,
  gettext,
  itstool,
  libtool,
  texinfo,
  util-linux,
  autoreconfHook,
  glib,
  dotconf,
  libsndfile,
  withLibao ? true,
  libao,
  withPulse ? false,
  libpulseaudio,
  withAlsa ? false,
  alsa-lib,
  withOss ? false,
  withFlite ? true,
  flite,
  withEspeak ? true,
  espeak,
  sonic,
  pcaudiolib,
  mbrola,
  withPico ? true,
  svox,
  libsOnly ? false,
}:

let
  inherit (python3Packages) python pyxdg wrapPython;
in
stdenv.mkDerivation rec {
  pname = "speech-dispatcher";
  version = "0.11.5";

  src = fetchurl {
    url = "https://github.com/brailcom/speechd/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-HOR1n/q7rxrrQzpewHOb4Gdum9+66URKezvhsq8+wSs=";
  };

  patches =
    [
      (replaceVars ./fix-paths.patch {
        utillinux = util-linux;
        # patch context
        bindir = null;
      })
    ]
    ++ lib.optionals (withEspeak && espeak.mbrolaSupport) [
      # Replace FHS paths.
      (replaceVars ./fix-mbrola-paths.patch {
        inherit mbrola;
      })
    ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    gettext
    libtool
    itstool
    texinfo
    wrapPython
  ];

  buildInputs =
    [
      glib
      dotconf
      libsndfile
      libao
      libpulseaudio
      alsa-lib
      python
    ]
    ++ lib.optionals withEspeak [
      espeak
      sonic
      pcaudiolib
    ]
    ++ lib.optionals withFlite [
      flite
    ]
    ++ lib.optionals withPico [
      svox
    ];

  pythonPath = [
    pyxdg
  ];

  configureFlags =
    [
      # Audio method falls back from left to right.
      "--with-default-audio-method=\"libao,pulse,alsa,oss\""
      "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    ]
    ++ lib.optionals withPulse [
      "--with-pulse"
    ]
    ++ lib.optionals withAlsa [
      "--with-alsa"
    ]
    ++ lib.optionals withLibao [
      "--with-libao"
    ]
    ++ lib.optionals withOss [
      "--with-oss"
    ]
    ++ lib.optionals withEspeak [
      "--with-espeak-ng"
    ]
    ++ lib.optionals withPico [
      "--with-pico"
    ];

  postPatch = ''
    substituteInPlace src/modules/pico.c --replace "/usr/share/pico/lang" "${svox}/share/pico/lang"
  '';

  postInstall =
    if libsOnly then
      ''
        rm -rf $out/{bin,etc,lib/speech-dispatcher,lib/systemd,libexec,share}
      ''
    else
      ''
        wrapPythonPrograms
      '';

  enableParallelBuilding = true;

  meta = with lib; {
    description =
      "Common interface to speech synthesis" + lib.optionalString libsOnly " - client libraries only";
    homepage = "https://devel.freebsoft.org/speechd";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      berce
      jtojnar
    ];
    platforms = platforms.linux;
    mainProgram = "speech-dispatcher";
  };
}
