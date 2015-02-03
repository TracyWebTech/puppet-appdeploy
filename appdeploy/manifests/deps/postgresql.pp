
class appdeploy::deps::postgresql {
  case $::osfamily {
    'Debian': { ensure_packages(['libpq-dev']) }
    'RedHat': { ensure_packages(['postgresql-devel']) }
  }
}
