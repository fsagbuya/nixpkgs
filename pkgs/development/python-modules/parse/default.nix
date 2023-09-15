{ lib, fetchPypi
, buildPythonPackage, python
}:
buildPythonPackage rec {
  pname = "parse";
  version = "1.19.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zDpHI2/wXaN3YX3e+oZ7e6mDgZxmThr+RiSeW0ab5GQ=";
  };

  checkPhase = ''
    ${python.interpreter} test_parse.py
  '';

  meta = with lib; {
    homepage = "https://github.com/r1chardj0n3s/parse";
    description = "parse() is the opposite of format()";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ alunduil ];
  };
}
