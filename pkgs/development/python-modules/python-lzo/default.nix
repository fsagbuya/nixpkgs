{ lib, fetchPypi, buildPythonPackage, lzo, nose }:

buildPythonPackage rec {
  pname = "python-lzo";
  version = "1.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pXqqAMXDoFFd2fdCa6LPYBdn3BncAj2LmdShOwoye0k=";
  };

  buildInputs = [ lzo ];
  propagatedBuildInputs = [ ];
  nativeCheckInputs = [ nose ];

  meta = with lib; {
    homepage = "https://github.com/jd-boyd/python-lzo";
    description = "Python bindings for the LZO data compression library";
    license = licenses.gpl2;
    maintainers = [ maintainers.jbedo ];
  };
}
