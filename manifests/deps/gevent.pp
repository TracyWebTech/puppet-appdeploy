
class appdeploy::deps::gevent {

  case $operatingsystem {
    'RedHat', 'CentOS': { $libev_dev = 'libev-dev' }
    /^(Debian|Ubuntu)$/:{ $libev_dev = 'libev-devel' }
  }
  ensure_packages([$libev_dev])

}
