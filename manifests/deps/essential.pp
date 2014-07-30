
class appdeploy::deps::essential {
  ensure_packages(['git', 'unzip'])

  case $osfamily {
    'RedHat': {
      exec { 'yum Group Install':
        unless  => '/usr/bin/yum grouplist "Development tools" | /bin/grep "^Installed Groups"',
        command => '/usr/bin/yum -y groupinstall "Development tools"',
      }
    }

    'Debian': { ensure_packages(['build-essential']) }
  }
}
