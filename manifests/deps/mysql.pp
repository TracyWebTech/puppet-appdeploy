
class appdeploy::deps::mysql {
  case $osfamily {
    'RedHat': {
      ensure_packages(['mysql-devel'])
    }
    'Debian': {
      ensure_packages(['libmysqlclient-dev'])
    }
  }
}
