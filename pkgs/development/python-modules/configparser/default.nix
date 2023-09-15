{ lib, stdenv, buildPythonPackage, fetchPypi, pytestCheckHook, setuptools-scm }:

buildPythonPackage rec {
  pname = "configparser";
  version = "6.0.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7JFKseVsZy3h9cNIOWTmj3GzTkV5BLe3bga5Iq7AZ6g=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  preConfigure = ''
    export LC_ALL=${if stdenv.isDarwin then "en_US" else "C"}.UTF-8
  '';

  meta = with lib; {
    description = "Updated configparser from Python 3.7 for Python 2.6+.";
    homepage = "https://github.com/jaraco/configparser";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
