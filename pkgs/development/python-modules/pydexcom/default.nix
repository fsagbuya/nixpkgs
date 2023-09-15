{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "pydexcom";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "gagebenne";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-VZ8Y8W3oEQ3W8eubMbHLfQAXK8cL6+OTyBFwtEe0cBE=";
  };

  propagatedBuildInputs = [ requests ];

  # tests are interacting with the Dexcom API
  doCheck = false;
  pythonImportsCheck = [ "pydexcom" ];

  meta = with lib; {
    description = "Python API to interact with Dexcom Share service";
    homepage = "https://github.com/gagebenne/pydexcom";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
