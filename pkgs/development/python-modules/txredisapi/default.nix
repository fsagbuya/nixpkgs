{ lib, buildPythonPackage, fetchFromGitHub, nixosTests, six, twisted }:

buildPythonPackage rec {
  pname = "txredisapi";
  version = "1.4.9";

  src = fetchFromGitHub {
    owner = "IlyaSkriblovsky";
    repo = "txredisapi";
    rev = "refs/tags/${version}";
    sha256 = "sha256-6Z2vurTAw9YHxvEiixtdxBH0YHj+Y9aTdsSkafPMZus=";
  };

  propagatedBuildInputs = [ six twisted ];

  doCheck = false;
  pythonImportsCheck = [ "txredisapi" ];

  passthru.tests.unit-tests = nixosTests.txredisapi;

  meta = with lib; {
    homepage = "https://github.com/IlyaSkriblovsky/txredisapi";
    description = "non-blocking redis client for python";
    license = licenses.asl20;
    maintainers = with maintainers; [ dandellion ];
  };
}

