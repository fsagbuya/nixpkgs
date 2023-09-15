{ lib, buildPythonPackage, fetchPypi, python }:

buildPythonPackage rec {
  pname = "diff-match-patch";
  version = "20230430";

  meta = {
    homepage = "https://github.com/diff-match-patch-python/diff-match-patch";
    description = "Diff, Match and Patch libraries for Plain Text";
    license = lib.licenses.asl20;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lTAZzbnJ0snke1sSvP889HRvxFmOtAYHb6H8J+ah8Vw=";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest -v diff_match_patch.tests
  '';
}
