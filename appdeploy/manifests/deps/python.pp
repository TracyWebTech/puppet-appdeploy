
class appdeploy::deps::python {
  require pip
  require appdeploy::deps::pythoncore

  pip::install { 'virtualenvwrapper': }

  # virtualenvwrapper load
  case $::osfamily {
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
