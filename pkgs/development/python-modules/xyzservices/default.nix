{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, mercantile
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "xyzservices";
  version = "2023.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DskodCIn1vXUNn6ntFf8/tlDQp9N4pSbWwKoLN9VadY=";
  };

  disabledTests = [
    # requires network connections
    "test_free_providers"
  ];

  pythonImportsCheck = [
    "xyzservices.providers"
  ];

  nativeCheckInputs = [
    mercantile
    pytestCheckHook
    requests
  ];

  meta = with lib; {
    changelog = "https://github.com/geopandas/xyzservices/releases/tag/${version}";
    description = "Source of XYZ tiles providers";
    homepage = "https://github.com/geopandas/xyzservices";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
