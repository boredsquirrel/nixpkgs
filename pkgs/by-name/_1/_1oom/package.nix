{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  autoreconfHook,
  allegro,
  libsamplerate,
  libGLU,
  libX11,
  libXext,
  SDL,
  SDL_mixer,
  SDL2,
  SDL2_mixer,
  readline,
}:

stdenv.mkDerivation rec {
  pname = "1oom";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "1oom-fork";
    repo = "1oom";
    tag = "v${version}";
    hash = "sha256-xvVl/XzOnItIvW0T3RpQ4tswqANHGWFvwnoY0+uHhx8=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    allegro
    libsamplerate
    libGLU
    libX11
    libXext
    SDL
    SDL_mixer
    SDL2
    SDL2_mixer
    readline
  ];

  outputs = [
    "out"
    "doc"
  ];

  postInstall = ''
    install -d $doc/share/doc/${pname}
    install -t $doc/share/doc/${pname} \
      HACKING NEWS PHILOSOPHY README.md doc/*.txt
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "f"; };

  meta = with lib; {
    homepage = "https://github.com/1oom-fork/1oom";
    changelog = "https://github.com/1oom-fork/1oom/releases/tag/v${version}";
    description = "Master of Orion (1993) game engine recreation; a more updated fork";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
