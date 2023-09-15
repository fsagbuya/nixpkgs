{ lib
, buildPythonPackage
, fetchFromGitHub
, rustPlatform
, stdenv
, libiconv
, brotli
, hypothesis
, lz4
, memory_profiler
, numpy
, py
, pytest-benchmark
, pytestCheckHook
, python-snappy
, zstd
}:

buildPythonPackage rec {
  pname = "cramjam";
  version = "2.7.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "milesgranger";
    repo = "pyrus-cramjam";
    rev = "refs/tags/v${version}";
    hash = "sha256-V1Dsk5zCBiGkgpMjEfExHg5Ju59KRQM89mq1d+aDLz0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-w1bEf+etLgR/YOyLmC3lFtO9fqAx8z2aul/XIKUQb5k=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  nativeCheckInputs = [
    brotli
    hypothesis
    lz4
    memory_profiler
    numpy
    py
    pytest-benchmark
    pytestCheckHook
    python-snappy
    zstd
  ];

  pytestFlagsArray = [
    "--benchmark-disable"
  ];

  disabledTestPaths = [
    "benchmarks/test_bench.py"
  ];

  pythonImportsCheck = [
    "cramjam"
  ];

  meta = with lib; {
    description = "Thin Python bindings to de/compression algorithms in Rust";
    homepage = "https://github.com/milesgranger/pyrus-cramjam";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
  };
}
