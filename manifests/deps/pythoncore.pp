
class appdeploy::deps::pythoncore {
  include pip
  require puias

  $package_defaults = {
    before => Class['pip'],
  }

  case $osfamily {
    'RedHat': { ensure_packages(['python27', 'python27-devel'], $package_defaults) }
    'Debian:': { ensure_packages(['python-dev'], $package_defaults) }
  }
}
