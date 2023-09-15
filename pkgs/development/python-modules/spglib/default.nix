{ lib, buildPythonPackage, fetchPypi, numpy, pytest, pyyaml }:

buildPythonPackage rec {
  pname = "spglib";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gUNUX9/8EfvNpNcFpra81Iid6bw1JLeN+GajbdDeCks=";
  };

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytest pyyaml ];

  # pytestCheckHook doesn't work
  # ImportError: cannot import name '_spglib' from partially initialized module 'spglib'
  checkPhase = ''
    pytest
  '';

  pythonImportsCheck = [ "spglib" ];

  meta = with lib; {
    description = "Python bindings for C library for finding and handling crystal symmetries";
    homepage = "https://spglib.github.io/spglib/";
    changelog = "https://github.com/spglib/spglib/raw/v${version}/ChangeLog";
    license = licenses.bsd3;
    maintainers = with maintainers; [ psyanticy ];
  };
}
