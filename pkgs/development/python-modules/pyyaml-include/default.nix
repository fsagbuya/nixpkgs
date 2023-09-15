{ lib, buildPythonPackage, fetchPypi
, pytestCheckHook
, pyyaml
, setuptools-scm
, setuptools-scm-git-archive
, toml
}:

buildPythonPackage rec {
  pname = "pyyaml-include";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TLO04bquLsJRgI/h6K7V09IGmcVBhkyOR+2GarLxUDk=";
  };

  nativeBuildInputs = [
    pyyaml
    setuptools-scm
    setuptools-scm-git-archive
    toml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "yamlinclude" ];

  meta = with lib; {
    description = "Extending PyYAML with a custom constructor for including YAML files within YAML files";
    homepage = "https://github.com/tanbro/pyyaml-include";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jonringer ];
  };
}
