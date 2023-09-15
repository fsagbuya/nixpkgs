{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "datauri";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "fcurella";
    repo = "python-datauri";
    rev = "refs/tags/v${version}";
    hash = "sha256-k4tlWRasGa2oQykCD9QJl65UAoZQMJVdyCfqlUBBgqY=";
  };

  pythonImportsCheck = [
    "datauri"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # UnicodeDecodeError: 'utf-8' codec can't decode
    "tests/test_file_ebcdic.txt"
  ];

  meta = with lib; {
    description = "Data URI manipulation made easy.";
    homepage = "https://github.com/fcurella/python-datauri";
    license = licenses.unlicense;
    maintainers = with maintainers; [ yuu ];
  };
}
