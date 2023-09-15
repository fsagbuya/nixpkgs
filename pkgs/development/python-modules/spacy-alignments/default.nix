{ lib
, stdenv
, cargo
, fetchPypi
, fetchpatch
, buildPythonPackage
, isPy3k
, rustPlatform
, rustc
, setuptools-rust
, libiconv
}:

buildPythonPackage rec {
  pname = "spacy-alignments";
  version = "0.9.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jcNYghWR9Xbu97/hAYe8ewa5oMQ4ofNGFwY4cY7/EmM=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-oFSruBnoodv6/0/OrmJ/2SVoWm3u3FGtzVJ9xgp0+Cg=";
  };

  nativeBuildInputs = [
    setuptools-rust
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  # Fails because spacy_alignments module cannot be loaded correctly.
  doCheck = false;

  pythonImportsCheck = [ "spacy_alignments" ];

  meta = with lib; {
    description = "Align tokenizations for spaCy and transformers";
    homepage = "https://github.com/explosion/spacy-alignments";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
