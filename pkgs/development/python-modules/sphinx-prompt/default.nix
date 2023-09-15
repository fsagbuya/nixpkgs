{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinxHook
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-prompt";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "sbrunner";
    repo = "sphinx-prompt";
    rev = "refs/tags/${version}";
    hash = "sha256-jgPD5DBpcj+/FqCI+lkycyYqQHnE8DQLrGLmr5iYBqE=";
  };

  propagatedBuildInputs = [ sphinx ];

  meta = with lib; {
    description = "A sphinx extension for creating unselectable prompt";
    homepage = "https://github.com/sbrunner/sphinx-prompt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kaction ];
  };
}
