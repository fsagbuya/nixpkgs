{ lib
, buildPythonPackage
, fetchpatch
, fetchFromGitHub
, cython
, nose
}:

buildPythonPackage rec {
  pname = "reedsolo";
  version = "1.7.0";

  # Pypi does not have the tests
  src = fetchFromGitHub {
    owner = "tomerfiliba";
    repo = "reedsolomon";
    rev = "refs/tags/v${version}";
    hash = "sha256-nzdD1oGXHSeGDD/3PpQQEZYGAwn9ahD2KNYGqpgADh0=";
  };

  patches = [
    (fetchpatch {
      # python3.10 compat; https://github.com/tomerfiliba/reedsolomon/pull/38
      url = "https://github.com/tomerfiliba/reedsolomon/commit/63e5bd9fc3ca503990c212eb2c77c10589e6d6c3.patch";
      hash = "sha256-47g+jUsJEAyqGnlzRA1oSyc2XFPUOfH0EW+vcOJzsxI=";
    })
  ];

  nativeBuildInputs = [ cython ];

  nativeCheckInputs = [ nose ];
  checkPhase = "nosetests";

  meta = with lib; {
    description = "Pure-python universal errors-and-erasures Reed-Solomon Codec";
    homepage = "https://github.com/tomerfiliba/reedsolomon";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ yorickvp ];
  };
}
