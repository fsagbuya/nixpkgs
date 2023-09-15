{ lib
, buildPythonPackage
, cloudscraper
, fetchFromGitHub
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "garminconnect";
  version = "0.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "python-garminconnect";
    rev = "refs/tags/${version}";
    hash = "sha256-AGpyNk9ocNLuFnYAG25yEpampzE6qaoXifp2bvfyKvk=";
  };

  propagatedBuildInputs = [
    cloudscraper
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "garminconnect"
  ];

  meta = with lib; {
    description = "Garmin Connect Python API wrapper";
    homepage = "https://github.com/cyberjunky/python-garminconnect";
    changelog = "https://github.com/cyberjunky/python-garminconnect/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
