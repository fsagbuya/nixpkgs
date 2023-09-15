{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "faadelays";
  version = "2023.8.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VAQQI9cMRKGe7RAUxoI1bBojzRq6cRz2jpeDA+GMuUI=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "faadelays" ];

  meta = with lib; {
    description = "Python package to retrieve FAA airport status";
    homepage = "https://github.com/ntilley905/faadelays";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
