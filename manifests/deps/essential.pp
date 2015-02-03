
class appdeploy::deps::essential {

  $git_pkg = $::lsbdistcodename ? {
    precise => 'git-core',
    default => 'git',
  }

  ensure_packages([$git_pkg, 'unzip', 'mercurial', 'bzr'])

  case $::osfamily {
    'RedHat': {
      exec { 'yum Group Install':
        unless  => '/usr/bin/yum grouplist "Development tools" ' \
                    '| /bin/grep "^Installed Groups"',
        command => '/usr/bin/yum -y groupinstall "Development tools"',
      }
    }

    'Debian': { ensure_packages(['build-essential']) }
  }
}
