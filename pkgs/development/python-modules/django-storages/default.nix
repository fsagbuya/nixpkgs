{ lib
, buildPythonPackage
, fetchPypi
, django
, azure-storage-blob
, boto3
, dropbox
, google-cloud-storage
, libcloud
, paramiko
}:

buildPythonPackage rec {
  pname = "django-storages";
  version = "1.14";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bJfl+q2CnJI6EmIgYoF0LEhNdtQ7MyoZbdzCQrkJxVE=";
  };

  propagatedBuildInputs = [
    django
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings
    # timezone issues https://github.com/jschneier/django-storages/issues/1171
    substituteInPlace tests/test_sftp.py \
      --replace 'test_accessed_time' 'dont_test_accessed_time' \
      --replace 'test_modified_time' 'dont_test_modified_time'
  '';

  nativeCheckInputs = [
    azure-storage-blob
    boto3
    dropbox
    google-cloud-storage
    libcloud
    paramiko
  ];

  pythonImportsCheck = [
    "storages"
  ];

  meta = with lib; {
    description = "Collection of custom storage backends for Django";
    homepage = "https://django-storages.readthedocs.io";
    changelog = "https://github.com/jschneier/django-storages/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
