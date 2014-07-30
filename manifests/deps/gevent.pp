
class appdeploy::deps::gevent {
  case $osfamily {
    'RedHat': { ensure_packages(['libev-devel']) }
    'Debian': { ensure_packages(['libev-dev']) }
  }
}
