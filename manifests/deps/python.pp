
class appdeploy::deps::python {
  require pip
  require appdeploy::deps::pythoncore

  package { 'virtualenvwrapper':
    ensure   => installed,
    provider => pip,
  }

  # virtualenvwrapper load
  case $osfamily {
    'RedHat': {
      file { '/etc/profile.d/virtualenvwrapper.sh':
        ensure => file,
        source => 'puppet:///modules/appdeploy/virtualenvwrapper.sh',
      }
    }

    'Debian': {
      file { '/etc/bash_completion.d/virtualenvwrapper.sh':
        ensure => link,
        target => '/usr/local/bin/virtualenvwrapper.sh',
      }
    }
  }

}
