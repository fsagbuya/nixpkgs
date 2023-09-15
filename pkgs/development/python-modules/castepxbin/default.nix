{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, pymatgen
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "castepxbin";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "zhubonan";
    repo = "castepxbin";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-6kumVnm4PLRxuKO6Uz0iHzfYuu21hFC7EPRsc3S1kxE=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    pymatgen
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A collection of readers for CASTEP binary outputs";
    homepage = "https://github.com/zhubonan/castepxbin";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
