{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, packaging
, ply
, toml
}:

buildPythonPackage rec {
  pname = "sip";
  version = "6.7.11";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8Nwyh6CxcuVmSTHIeEd1DUfk/c2k/jYrUUr47dZVtGk=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ packaging ply toml ];

  # There aren't tests
  doCheck = false;

  pythonImportsCheck = [ "sipbuild" ];

  meta = with lib; {
    description = "Creates C++ bindings for Python modules";
    homepage    = "https://riverbankcomputing.com/";
    license     = licenses.gpl3Only;
    maintainers = with maintainers; [ nrdxp ];
  };
}
