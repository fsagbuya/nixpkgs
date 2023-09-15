{ lib
, buildPythonPackage
, fetchPypi
, mock
, pytest-asyncio
, pytest-trio
, pytestCheckHook
, pythonOlder
, twisted
, typing-extensions
, vcversioner
}:

buildPythonPackage rec {
  pname = "pyee";
  version = "11.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J8aCvOYL2txdPiPqzUEB3zKMAoCISj2cB/Ok4+WV3ic=";
  };

  buildInputs = [
    vcversioner
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytest-trio
    pytestCheckHook
    twisted
  ];

  pythonImportsCheck = [
    "pyee"
  ];

  meta = with lib; {
    description = "A port of Node.js's EventEmitter to Python";
    homepage = "https://github.com/jfhbrook/pyee";
    license = licenses.mit;
    maintainers = with maintainers; [ kmein ];
  };
}
