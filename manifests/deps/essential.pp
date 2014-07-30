
class appdeploy::deps::essential {
  ensure_packages([
    'git',
    'unzip',
  ])

  case $osfamily {
    'redhat': {
      exec { 'yum Group Install':
        unless  => '/usr/bin/yum grouplist "Development tools" | /bin/grep "^Installed Groups"',
        command => '/usr/bin/yum -y groupinstall "Development tools"',
      }
    }

    'debian': {
      ensure_packages(['build-essential'])
    }
  }
}
