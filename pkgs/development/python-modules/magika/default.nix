{
  lib,
  buildPythonPackage,
  click,
  fetchPypi,
  magika,
  numpy,
  onnxruntime,
  poetry-core,
  python-dotenv,
  pythonOlder,
  stdenv,
  tabulate,
  testers,
  tqdm,
}:

buildPythonPackage rec {
  pname = "magika";
  version = "0.6.1";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-490ixzk2Ywsc150PQS1tmlPcmbpeNwmxrFP1a8mY5jU=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    click
    numpy
    onnxruntime
    python-dotenv
    tabulate
    tqdm
  ];

  pythonImportsCheck = [ "magika" ];

  passthru.tests.version = testers.testVersion { package = magika; };

  meta = with lib; {
    description = "Magika: Detect file content types with deep learning";
    homepage = "https://github.com/google/magika";
    license = licenses.asl20;
    maintainers = with maintainers; [ mihaimaruseac ];
    mainProgram = "magika";
    # Currently, disabling on AArch64 as it onnx runtime crashes on ofborg
    broken = stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux;
  };
}
